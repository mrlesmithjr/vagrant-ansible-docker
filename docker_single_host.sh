#!/bin/bash
cp nodes.yml.single nodes.yml
vagrant up
sudo ansible-galaxy install -r requirements.yml -f
vagrant ssh -c "sudo ansible-galaxy install -r /vagrant/requirements.yml -f" node-1
ansible-playbook -i hosts docker.yml --user vagrant
