#!/bin/bash

attack="/home/ubuntu/Security-on-Docker/Attacks/Nsenter/Mount_hosts_filesystem"

container_pid=$(cat PID)

nsenter --target ${container_pid} --mount --pid -- umount /tmpmount

rm PID
rm dockerps
rm containerid
rm major_num
rm minor_num
rm sdev_of_fs
