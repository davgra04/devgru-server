#!/bin/bash

set -x

################################################################################
# GLOBAL VARS

################################################################################
# UPGRADE AND INSTALL STUFF

# make sure everything is up to date
sudo yum -y update
sudo yum -y upgrade

# handy stuff that I want to have for troubleshooting
sudo yum -y install vim tree lsof

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
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/pki/nginx/private/server.key -out /etc/pki/nginx/server.crt -subj "/CN=devgru.cc/O=devgru-server/C=US"

# Create dgserv user to run services
sudo useradd --system dgserv

# Create directory for deploying apps
sudo mkdir /dgserv
sudo chown dgserv:dgserv /dgserv

# Configure SELinux to allow HTTP traffic. As per https://unix.stackexchange.com/a/198769
sudo setsebool -P httpd_can_network_connect true

# not sure what I'm doing here yet, but the default nginx page is availble to visit!
sudo systemctl enable nginx
sudo systemctl start nginx

echo "HEYO BOYO! I picked meself up by me bootstraps!"
