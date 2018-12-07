#!/bin/sh

attack="/home/ubuntu/Security-on-Docker/Attacks/Hosts_fs/privileged_attacker"

#Clear logs
./clear_logs.sh

#Clear all docker filesystems/images/network etc
docker system prune -a

#Layers in container's filesystem
sudo ls /var/lib/docker/aufs/diff
#Choose one and create a dir there
echo "Please give layer's id:"
read path
sudo mkdir /var/lib/docker/aufs/diff/${path}/doot
mkdir ${attack}/restricted_area
touch ${attack}/restricted_area/HellloFromTheOtherSide

#Then mount a host directory to doot
sudo mount -o bind ${attack}/restricted_area /var/lib/docker/aufs/diff/${path}/doot

#Get some info around mount
df ${attack}/restricted_area > df
sudo cat /proc/self/mountinfo > mountinfo



