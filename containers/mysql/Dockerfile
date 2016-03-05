FROM ubuntu:14.04

MAINTAINER Larry Smith Jr. <mrlesmithjr@gmail.com>

#Update apt-cache
RUN apt-get update

#Install MySQL
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server

#Clean-up packages
RUN apt-get -y clean && \
    apt-get -y autoremove

#Clean-up temp files
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Expose port(s)
EXPOSE 3306

#Process start-up
CMD ["/usr/bin/mysqld_safe"]
