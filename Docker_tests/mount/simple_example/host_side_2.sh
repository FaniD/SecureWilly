#!/bin/sh

read container_id
docker inspect --format {{.State.Pid}} ${container_id} > PID
P = echo $(cat PID)
sudo nsenter --target ${P} --mount --uts --ipc --net --pid -- mount /dev/vda1 /tmpmount



