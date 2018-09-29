#!/bin/sh

echo "Please give container's id:"
read container_id
docker inspect --format {{.State.Pid}} ${container_id} > PID
container_pid=$(cat PID)
sudo nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- mount /dev/vda1 /tmpmount

#I can doo mkdir and mknod with nsenter too -> version 4

#Version 3
#sudo nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- mount -o bind /tmpmount/home/ubuntu/Security-on-Docker/Docker_tests/mount/attack_host_to_container/restricted_area /doot

sudo nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- umount /tmpmount
