#!/bin/bash
#
# vars
consul_host=192.168.202.200
overlay_network=my-net
#
ansible-galaxy install -r requirements.yml -f -p ./roles
cp Vagrantfile.multi Vagrantfile
vagrant up
docker-machine create -d generic \
    --generic-ip-address="192.168.202.200" \
    --generic-ssh-user="vagrant" \
    --generic-ssh-key=".vagrant/machines/node0/virtualbox/private_key" \
  node0
eval $(docker-machine env node0)
docker pull progrium/consul
docker run -d \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap
docker-machine create -d generic \
    --swarm --swarm-master \
    --generic-ip-address="192.168.202.201" \
    --generic-ssh-user="vagrant" \
    --generic-ssh-key=".vagrant/machines/node1/virtualbox/private_key" \
    --swarm-discovery="consul://$consul_host:8500" \
    --engine-opt="cluster-store=consul://$consul_host:8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  node1
docker-machine create -d generic \
    --swarm \
    --generic-ip-address="192.168.202.202" \
    --generic-ssh-user="vagrant" \
    --generic-ssh-key=".vagrant/machines/node2/virtualbox/private_key" \
    --swarm-discovery="consul://$consul_host:8500" \
    --engine-opt="cluster-store=consul://$consul_host:8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  node2
docker-machine create -d generic \
    --swarm \
    --generic-ip-address="192.168.202.203" \
    --generic-ssh-user="vagrant" \
    --generic-ssh-key=".vagrant/machines/node3/virtualbox/private_key" \
    --swarm-discovery="consul://$consul_host:8500" \
    --engine-opt="cluster-store=consul://$consul_host:8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  node3
eval "$(docker-machine env --swarm node1)"
docker network create --driver overlay $overlay_network
