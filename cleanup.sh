#!/bin/bash
vagrant destroy -f
rm -rf .vagrant
rm host_vars/*
touch host_vars/dummy
