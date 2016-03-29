#!/bin/bash
ansible-galaxy install -r requirements.yml -f -p ./roles
cp Vagrantfile.single Vagrantfile
vagrant up
