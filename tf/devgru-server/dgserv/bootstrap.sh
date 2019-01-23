#!/bin/bash

echo "HEYO BOYO! I picked meself up by me bootstraps!"

set -x

################################################################################
# GLOBAL VARS

################################################################################
# UPGRADE AND INSTALL STUFF

# make sure everything is up to date
sudo yum -y update
sudo yum -y upgrade

# handy stuff that I want to have for troubleshooting
sudo yum -y install vim tree

# install and start nginx
sudo yum -y install epel-release
sudo yum -y install nginx

################################################################################
# CONFIGURE AND START WEB SERVER

# copy config
sudo cp /home/centos/dgserv/nginx.conf /etc/nginx/nginx.conf

# copy 40x and 50x pages
sudo mkdir -p /usr/share/nginx/devgru.cc
sudo cp -r /home/centos/dgserv/html /usr/share/nginx/devgru.cc
sudo cp /usr/share/nginx/devgru.cc/html/40x.html /usr/share/nginx/devgru.cc/html/50x.html

# generate HTTPS key
sudo mkdir -p /etc/pki/nginx/private

# echo -e "US\nTexas\nHouston\ndevgru-server\ndevgru-server\ndevgru.cc\devgru@devgru.cc" | sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/pki/nginx/private/server.key -out /etc/pki/nginx/server.crt

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/pki/nginx/private/server.key -out /etc/pki/nginx/server.crt -subj "/CN=devgru.cc/O=devgru-server/C=US"


# not sure what I'm doing here yet, but the default nginx page is availble to visit!
sudo systemctl start nginx

