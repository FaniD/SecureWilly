#!/bin/sh
sudo apt-get update

#Upgrade docker-engine
sudo apt-get upgrade docker-engine

#Install docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#Apparmor & apparmor utils
sudo apt-get install apparmor
sudo apt-get install apparmor-utils

#Install python
sudo apt-get install python

#Install nsenter with a trick
echo "#On docker container" > nsenter_trick_docker
echo "apt-get update" >> nsenter_trick_docker
echo "apt-get install git build-essential libncurses5-dev libslang2-dev gettext zlib1g-dev libselinux1-dev debhelper lsb-release pkg-config po-debconf autoconf automake autopoint libtool" >> nsenter_trick_docker
echo "git clone git://git.kernel.org/pub/scm/utils/util-linux/util-linux.git util-linux" >> nsenter_trick_docker
echo "cd util-linux/" >> nsenter_trick_docker
echo "./autogen.sh" >> nsenter_trick_docker
echo "./configure --without-python --disable-all-programs --enable-nsenter" >> nsenter_trick_docker
echo "make" >> nsenter_trick_docker

echo "## from different shell - on the host" > nsenter_trick_host.sh
echo "docker cp nsenter:/util-linux/nsenter /usr/local/bin/" >> nsenter_trick_host.sh
echo "docker cp nsenter:/util-linux/bash-completion/nsenter /etc/bash_completion.d/nsenter" >> nsenter_trick_host.sh
sudo chmod 777 nsenter_trick_host.sh

docker run --name nsenter -it ubuntu:14.04 bash


