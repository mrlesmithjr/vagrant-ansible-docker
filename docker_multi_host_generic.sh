#!/bin/bash
#
# vars
consul_host=192.168.202.34
overlay_network=my-net
#
cp nodes.yml.multi nodes.yml
vagrant up
docker-machine create -d generic \
    --generic-ip-address="192.168.202.34" \
    --generic-ssh-user="vagrant" \
    --generic-ssh-key=".vagrant/machines/kv/virtualbox/private_key" \
  kv
eval $(docker-machine env kv)
docker pull progrium/consul
docker run -d \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap
docker-machine create -d generic \
    --swarm --swarm-master \
    --generic-ip-address="192.168.202.35" \
    --generic-ssh-user="vagrant" \
    --generic-ssh-key=".vagrant/machines/c0-master/virtualbox/private_key" \
    --swarm-discovery="consul://$consul_host:8500" \
    --engine-opt="cluster-store=consul://$consul_host:8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  c0-master
docker-machine create -d generic \
    --swarm \
    --generic-ip-address="192.168.202.36" \
    --generic-ssh-user="vagrant" \
    --generic-ssh-key=".vagrant/machines/c0-n1/virtualbox/private_key" \
    --swarm-discovery="consul://$consul_host:8500" \
    --engine-opt="cluster-store=consul://$consul_host:8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  c0-n1
docker-machine create -d generic \
    --swarm \
    --generic-ip-address="192.168.202.37" \
    --generic-ssh-user="vagrant" \
    --generic-ssh-key=".vagrant/machines/c0-n2/virtualbox/private_key" \
    --swarm-discovery="consul://$consul_host:8500" \
    --engine-opt="cluster-store=consul://$consul_host:8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  c0-n2
#eval "$(docker-machine env --swarm c0-master)"
#docker network create --driver overlay $overlay_network
