#!/bin/sh

#Create a block device to mount
mknod --mode 0600 /dev/vda1 b 253 1

#Create a directory for host filesystem and mount it to device /var/vda1
mkdir -p /tmpmount
mount /dev/vda1 /tmpmount

#Bind mount to /doot
mount -o bind /tmpmount/home/ubuntu/Security-on-Docker/Docker_tests/mount/simple_example/restricted_area /doot

#See if host's files exist in doot
ls /doot
