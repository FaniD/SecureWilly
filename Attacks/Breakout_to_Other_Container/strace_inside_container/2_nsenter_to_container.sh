#!/bin/sh

docker ps | grep strace-ubuntu > dockerps
cut -d' ' -f1 dockerps > containerid
container_id=$(cat containerid)
docker inspect --format {{.State.Pid}} ${container_id} > PID
container_pid=$(cat PID)
rm PID

#Attack container
sudo nsenter --target ${container_pid} --mount sh

sudo rm dockerps
sudo rm containerid
