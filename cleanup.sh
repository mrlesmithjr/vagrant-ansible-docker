#!/bin/bash
vagrant destroy -f
rm -rf .vagrant
rm host_vars/*
touch host_vars/dummy
docker-machine rm mh-keystore -f
docker-machine rm mhs-demo0 -f
docker-machine rm mhs-demo1 -f
docker-machine rm mhs-demo2 -f
docker-machine rm kv -f
docker-machine rm c0-master -f
docker-machine rm c0-n1 -f
docker-machine rm c0-n2 -f
