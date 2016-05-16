#!/bin/bash
vagrant destroy -f
docker-machine rm mh-keystore -f
for (( num=0; num<=3; num++ ))
do
 docker-machine rm mhs-demo$num -f
 docker-machine rm node$num -f
done
for file in *.retry; do
  if [[ -f $file ]]; then
    rm $file
  fi
done
if [ -d group_vars ]; then
  rm -rf group_vars
fi
if [ -d host_vars ]; then
  rm -rf host_vars
fi
if [ -d .vagrant ]; then
  rm -rf .vagrant
fi
if [ -d roles ]; then
  rm -rf roles
fi
rm Vagrantfile
