#!/bin/bash
#
# vars
consul_host=192.168.202.34
overlay_network=my-net
#
cp nodes.yml.multi nodes.yml
vagrant up
#sudo ansible-galaxy install -r requirements.yml -f
#vagrant ssh -c "sudo ansible-galaxy install -r /vagrant/requirements.yml -f" kv
#vagrant ssh -c "sudo ansible-galaxy install -r /vagrant/requirements.yml -f" c0-master
#vagrant ssh -c "sudo ansible-galaxy install -r /vagrant/requirements.yml -f" c0-n1
#vagrant ssh -c "sudo ansible-galaxy install -r /vagrant/requirements.yml -f" c0-n2
#ansible-playbook -i hosts docker.yml --user vagrant
docker-machine create -d generic --generic-ip-address 192.168.202.34 --generic-ssh-user vagrant --generic-ssh-key .vagrant/machines/kv/virtualbox/private_key kv
eval $(docker-machine env kv)
docker pull progrium/consul
docker run -d --name consul -p 8400:8400 -p 8500:8500 -p 8600:53/udp -h node1 progrium/consul -server -bootstrap -ui-dir /ui
#docker-machine create -d generic --generic-ip-address 192.168.202.35 --generic-ssh-user vagrant --generic-ssh-key .vagrant/machines/c0-master/virtualbox/private_key c0-master
docker-machine create -d generic --generic-ip-address 192.168.202.35 --generic-ssh-user vagrant --generic-ssh-key .vagrant/machines/c0-master/virtualbox/private_key --swarm --swarm-master --swarm-discovery consul://$consul_host:8500/ c0-master
docker-machine create -d generic --generic-ip-address 192.168.202.36 --generic-ssh-user vagrant --generic-ssh-key .vagrant/machines/c0-n1/virtualbox/private_key --swarm --swarm-discovery consul://$consul_host:8500/ c0-n1
docker-machine create -d generic --generic-ip-address 192.168.202.37 --generic-ssh-user vagrant --generic-ssh-key .vagrant/machines/c0-n2/virtualbox/private_key --swarm --swarm-discovery consul://$consul_host:8500/ c0-n2
eval "$(docker-machine env --swarm c0-master)"
docker network create --driver overlay $overlay_network
