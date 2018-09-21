#!/bin/sh

#Layers in container's filesystem
sudo ls /var/lib/docker/aufs/diff
#Choose one and create a dir there
read path
sudo mkdir /var/lib/docker/aufs/diff/${path}/doot
sudo touch /home/ubuntu/Security-on-Docker/Docker_tests/mount/simple_example/restricted_area/HellloFromTheOtherSide

#Then mount a host directory to doot
sudo mount -o bind /home/ubuntu/Security-on-Docker/Docker_tests/mount/simple_example/restricted_area /var/lib/docker/aufs/diff/${path}/doot

#Get some info around mount
df /home/ubuntu/Security-on-Docker/Docker_tests/mount/simple_example/restricted_area > df
sudo cat /proc/self/mountinfo > mountinfo



