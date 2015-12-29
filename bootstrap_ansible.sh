#!/bin/bash
apt-get install -y python-pip python-dev
pip install ansible

ansible-galaxy install mrlesmithjr.bootstrap
ansible-galaxy install mrlesmithjr.base
