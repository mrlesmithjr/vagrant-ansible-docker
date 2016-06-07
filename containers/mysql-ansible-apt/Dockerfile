FROM debian:jessie

MAINTAINER Larry Smith Jr. <mrlesmithjr@gmail.com>

#Copy Ansible tasks
COPY ansible_tasks /opt/ansible_tasks

#Update apt-cache, install Ansible and install Ansible roles
RUN apt-get update && \
    apt-get -y install git software-properties-common && \
    apt-add-repository ppa:ansible/ansible && \
    apt-get update && \
    apt-get -y install ansible && \
    ansible-galaxy install -r /opt/ansible_tasks/requirements.yml && \
    ansible-playbook -i "localhost," -c local /opt/ansible_tasks/playbook.yml && \
    apt-get -y clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Expose port(s)
EXPOSE 3306

#Process start-up
CMD ["/usr/bin/mysqld_safe"]
