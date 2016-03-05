FROM ubuntu:14.04

MAINTAINER Larry Smith Jr. <mrlesmithjr@gmail.com>

#Update apt-cache
RUN apt-get update

#Install pre-reqs for Ansible
RUN apt-get -y install git python-dev python-pip

#Install Ansible
RUN pip install ansible

#Copy Ansible tasks
COPY ansible_tasks /opt/ansible_tasks

#Install Ansible role(s)
RUN ansible-galaxy install -r /opt/ansible_tasks/requirements.yml

#Run Ansible playbook
RUN ansible-playbook -c local /opt/ansible_tasks/playbook.yml

#Clean-up packages
RUN apt-get -y clean && \
    apt-get -y autoremove

#Clean-up temp files
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Expose port(s)
EXPOSE 3306

#Process start-up
CMD ["/usr/bin/mysqld_safe"]
