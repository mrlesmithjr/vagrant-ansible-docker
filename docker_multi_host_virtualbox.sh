#!/usr/bin/env bash
#
# vars
overlay_network=my-net
#
docker-machine create -d virtualbox mh-keystore
docker $(docker-machine config mh-keystore) run -d \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap
eval "$(docker-machine env mh-keystore)"
docker-machine create -d virtualbox \
    --swarm --swarm-master \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  mhs-demo0
docker-machine create -d virtualbox \
    --swarm \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  mhs-demo1
docker-machine create -d virtualbox \
    --swarm \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  mhs-demo2
eval $(docker-machine env --swarm mhs-demo0)
docker network create --driver overlay $overlay_network
