#!/bin/bash

#Attacking directory where attacker's scripts are 
attack="/home/ubuntu/SecureWilly/Attacks/Nsenter/Mount_hosts_filesystem"

#Files created on previous scripts
container_pid=$(cat PID)

#Umount host's directory from tmpmount
nsenter --target ${container_pid} --mount --pid -- umount /tmpmount
#Umount host's restricted_area from doot when the attack is over
nsenter --target ${container_pid} --mount --pid -- umount /doot

#Clear files
rm PID
rm dockerps
rm containerid
rm major_num
rm minor_num
rm sdev_of_fs*
