#!/usr/bin/env bash
git clone https://github.com/mrlesmithjr/ansible.git /root/ansible
rm -rf /etc/ansible/roles
ln -s /root/ansible/roles /etc/ansible
/bin/bash
