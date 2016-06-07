FROM debian:jessie

MAINTAINER Larry Smith Jr. <mrlesmithjr@gmail.com>

#Update apt-cache and install redis
RUN apt-get update && \
    apt-get -y install redis-server && \
    apt-get -y clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Expose ports
EXPOSE 6379

ENTRYPOINT  ["/usr/bin/redis-server"]
