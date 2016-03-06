#!/bin/bash
#ansible-playbook -i hosts docker.yml --user vagrant
#ansible-playbook -i hosts docker_swarm.yml --user vagrant
docker-machine create -d generic --generic-ip-address 192.168.202.200 --generic-ssh-user vagrant --generic-ssh-key .vagrant/machines/node0/virtualbox/private_key node0
docker-machine create -d generic --generic-ip-address 192.168.202.201 --generic-ssh-user vagrant --generic-ssh-key .vagrant/machines/node1/virtualbox/private_key node1
docker-machine create -d generic --generic-ip-address 192.168.202.202 --generic-ssh-user vagrant --generic-ssh-key .vagrant/machines/node2/virtualbox/private_key node2
docker-machine create -d generic --generic-ip-address 192.168.202.203 --generic-ssh-user vagrant --generic-ssh-key .vagrant/machines/node3/virtualbox/private_key node3
