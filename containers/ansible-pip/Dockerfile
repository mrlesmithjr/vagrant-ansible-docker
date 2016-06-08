FROM ubuntu:16.04

MAINTAINER Larry Smith Jr. <mrlesmithjr@gmail.com>

RUN apt-get update && \
    apt-get -y install build-essential git libssl-dev libffi-dev python-dev python-setuptools && \
    easy_install pip && \
    pip install --upgrade setuptools && \
    pip install ansible && \
    apt-get -y purge build-essential libssl-dev libffi-dev python-dev python-setuptools && \
    apt-get -y clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

