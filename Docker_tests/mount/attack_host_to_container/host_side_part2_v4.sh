#!/bin/sh

echo "Please give container's id:"
read container_id
docker inspect --format {{.State.Pid}} ${container_id} > PID
container_pid=$(cat PID)

sudo nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- mknod --mode 0600 /dev/vda1 b 253 1

sudo nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- mkdir -p /tmpmount

sudo nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- mount /dev/vda1 /tmpmount

sudo nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- mount -o bind /tmpmount/home/ubuntu/Security-on-Docker/Docker_tests/mount/simple_example/restricted_area /doot

sudo nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- umount /tmpmount
