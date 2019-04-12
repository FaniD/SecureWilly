#!/bin/sh
sudo apt-get update

sudo apt-get install docker.io
sudo apt-get install docker-compose

#Older version
#Upgrade docker-engine
#sudo apt-get upgrade docker-engine

#Install docker-compose
#sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
#sudo chmod +x /usr/local/bin/docker-compose

#Apparmor & apparmor utils
sudo apt-get install apparmor

sudo apt-get install apparmor-utils

#Install python
sudo apt-get install python

sudo apt-get install python-matplotlib

#Install nsenter with a trick
docker run --name nsenter -it ubuntu:14.04 bash


