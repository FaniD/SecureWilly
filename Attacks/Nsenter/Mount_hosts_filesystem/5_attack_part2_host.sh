#!/bin/bash

attack="/home/ubuntu/Security-on-Docker/Attacks/Nsenter/Mount_hosts_filesystem"

container_pid=$(cat PID)
dev=$(cat sdev_of_fs)

#Done by  host
nsenter --target ${container_pid} --mount --pid -- mount ${dev} /tmpmount
