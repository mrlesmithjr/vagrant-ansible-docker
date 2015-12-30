#!/bin/bash
#ansible-playbook -i hosts docker.yml --user vagrant
#ansible-playbook -i hosts docker_swarm.yml --user vagrant
docker-machine create -d generic --generic-ip-address 192.168.202.34 --generic-ssh-user vagrant --generic-ssh-key .vagrant/machines/kv/virtualbox/private_key kv
docker-machine create -d generic --generic-ip-address 192.168.202.35 --generic-ssh-user vagrant --generic-ssh-key .vagrant/machines/c0-master/virtualbox/private_key c0-master
docker-machine create -d generic --generic-ip-address 192.168.202.36 --generic-ssh-user vagrant --generic-ssh-key .vagrant/machines/kv/virtualbox/private_key c0-n1
docker-machine create -d generic --generic-ip-address 192.168.202.37 --generic-ssh-user vagrant --generic-ssh-key .vagrant/machines/kv/virtualbox/private_key c0-n2
