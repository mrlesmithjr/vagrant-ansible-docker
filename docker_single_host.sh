#!/bin/bash
ansible-galaxy install -r requirements.yml -f
cp Vagrantfile.single Vagrantfile
vagrant up
