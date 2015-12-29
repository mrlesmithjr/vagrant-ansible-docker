Purpose
=======

Spins up a Vagrant environment for testing Docker. Also allows you to learn Ansible along with Docker.

Requirements
============

Ansible (http://www.ansible.com/home)

VirtualBox (https://www.virtualbox.org/)

Vagrant (https://www.vagrantup.com/)

Usage
=====

````
git clone https://github.com/mrlesmithjr/vagrant-ansible-docker.git
cd vagrant-ansible-docker
````
Update nodes.yml to reflect your desired nodes to spin up.

Spin up your environment
````
vagrant up
````

To run ansible from within Vagrant nodes (Ex. site.yml)
````
vagrant ssh
cd /vagrant
sudo ansible-galaxy install -r requirements.yml
ansible-playbook -i "localhost," -c local docker.yml
````

Variable Definitions
====================
````
nodes.yml
````
Define the nodes to spin up
````
---
- name: node-1
  box: mrlesmithjr/trusty64
  mem: 4096
  cpus: 2
  ansible_ssh_host_ip: 192.168.202.33 #always create for Ansible provisioning within nodes
  config_interfaces: "False"  #defines if interfaces below should be created or not...Set to "False" if you do not wish to create the interfaces.
  interfaces:  #Define additional interface settings
    - ip: 192.168.12.11
      auto_config: "True"
      network_name: 01-to-02
      method: static
      type: private_network
````

Ansible Playbooks Used
======================
````
bootstrap.yml
````
````
---
- hosts: all
  remote_user: vagrant
  sudo: yes
  vars:
    - galaxy_roles:
      - mrlesmithjr.bootstrap
      - mrlesmithjr.base
    - install_galaxy_roles: false
    - ssh_key_path: '.vagrant/machines/{{ inventory_hostname }}/virtualbox/private_key'
    - update_host_vars: true
  roles:
  tasks:
    - name: updating apt cache
      apt:
        update_cache: yes
        cache_valid_time: 3600
      when: ansible_os_family == "Debian"

    - name: installing ansible pre-reqs
      apt:
        name: "{{ item }}"
        state: present
      with_items:
        - git
        - python-pip
        - python-dev
      when: ansible_os_family == "Debian"

    - name: adding ansible ppa
      apt_repository:
        repo: "ppa:ansible/ansible"
      when: ansible_os_family == "Debian"

    - name: installing ansible
      apt:
        name: ansible
        state: latest
      when: ansible_os_family == "Debian"

    - name: installing epel repo
      yum:
        name: epel-release
        state: present
      when: ansible_os_family == "RedHat"

    - name: installing Ansible pre-reqs
      yum:
        name: "{{ item }}"
        state: present
      with_items:
        - git
      when: ansible_os_family == "Redhat"

    - name: installing ansible
      yum:
        name: ansible
        state: present
      when: ansible_os_family == "RedHat"

    - name: installing ansible-galaxy roles
      shell: ansible-galaxy install {{ item }} --force
      with_items: galaxy_roles
      when: install_galaxy_roles is defined and install_galaxy_roles

    - name: ensuring host file exists in host_vars
      stat:
        path: "./host_vars/{{ inventory_hostname }}"
      delegate_to: localhost
      register: host_var
      sudo: false
      when: update_host_vars is defined and update_host_vars

    - name: creating missing host_vars
      file:
        path: "./host_vars/{{ inventory_hostname }}"
        state: touch
      delegate_to: localhost
      sudo: false
      when: not host_var.stat.exists

    - name: updating ansible_ssh_port
      lineinfile:
        dest: "./host_vars/{{ inventory_hostname }}"
        regexp: "^ansible_ssh_port{{ ':' }}"
        line: "ansible_ssh_port{{ ':' }} 22"
      delegate_to: localhost
      sudo: false
      when: update_host_vars is defined and update_host_vars

    - name: updating ansible_ssh_host
      lineinfile:
        dest: "./host_vars/{{ inventory_hostname }}"
        regexp: "^ansible_ssh_host{{ ':' }}"
        line: "ansible_ssh_host{{ ':' }} {{ ansible_eth1.ipv4.address }}"
      delegate_to: localhost
      sudo: false
      when: update_host_vars is defined and update_host_vars and ansible_eth1 is defined

    - name: updating ansible_ssh_host
      lineinfile:
        dest: "./host_vars/{{ inventory_hostname }}"
        regexp: "^ansible_ssh_host{{ ':' }}"
        line: "ansible_ssh_host{{ ':' }} {{ ansible_enp0s8.ipv4.address }}"
      delegate_to: localhost
      sudo: false
      when: update_host_vars is defined and update_host_vars and ansible_enp0s8 is defined

    - name: updating ansible_ssh_key
      lineinfile:
        dest: "./host_vars/{{ inventory_hostname }}"
        regexp: "^ansible_ssh_private_key_file{{ ':' }}"
        line: "ansible_ssh_private_key_file{{ ':' }} {{ ssh_key_path }}"
      delegate_to: localhost
      sudo: false
      when: update_host_vars is defined and update_host_vars

    - name: ensuring host_vars is yaml formatted
      lineinfile:
        dest: "./host_vars/{{ inventory_hostname }}"
        regexp: "---"
        line: "---"
        insertbefore: BOF
      delegate_to: localhost
      sudo: false
      when: update_host_vars is defined and update_host_vars
````

````
docker.yml
````
````
---
- name: installs docker package(s)
  hosts: all
  remote_user: vagrant
  sudo: yes
  vars:
    - configure_firewall: true
    - docker_images:
      - image: ubuntu
        state: present
    - docker_opts:  #defines docker service options to be configured
      - '--dns {{ pri_dns }}'
      - '--dns {{ sec_dns }}'
      - '--insecure-registry 192.168.202.34:5000'
    - pri_dns: 8.8.8.8  #defines primary dns server for your site
    - sec_dns: 8.8.4.4  #defines secondary dns server for your site
    - ufw_policies:  #defines default policy for incoming, outgoing and routed (forwarded) traffic...allow, deny or reject
      - direction: incoming
        policy: deny
      - direction: outgoing
        policy: allow
      - direction: routed
        policy: allow
    - ufw_rules:
      - rule: limit
        proto: tcp
        to_port: 22
      - rule: allow
        proto: tcp
        to_port: 2375
      - rule: allow
        proto: tcp
        to_port: 9200
      - rule: allow
        proto: tcp
        to_port: 9300
      - rule: allow
        proto: udp
        to_port: 54328
  roles:
    - role: ansible-docker
    - role: ansible-ufw
      when: configure_firewall is defined and configure_firewall
  tasks:
````

License
-------

BSD

Author Information
------------------

Larry Smith Jr.
- @mrlesmithjr
- http://everythingshouldbevirtual.com
- mrlesmithjr [at] gmail.com
