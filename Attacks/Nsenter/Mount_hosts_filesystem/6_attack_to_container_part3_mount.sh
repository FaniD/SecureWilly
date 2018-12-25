#!/bin/bash

attack="/home/ubuntu/SecureWilly/Attacks/Nsenter/Mount_hosts_filesystem"

container_pid=$(cat PID)

nsenter --target ${container_pid} --mount --pid -- mount -o bind /tmpmount/${attack}/restricted_area /doot
