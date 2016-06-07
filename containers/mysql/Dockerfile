FROM debian:jessie

MAINTAINER Larry Smith Jr. <mrlesmithjr@gmail.com>

#Update apt-cache and install mySQL
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server && \
    apt-get -y clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Expose port(s)
EXPOSE 3306

#Process start-up
CMD ["/usr/bin/mysqld_safe"]
