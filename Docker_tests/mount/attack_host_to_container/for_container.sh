#bin/bash

#Version 5
nsenter --mount=/media/host/proc/1/ns/mnt -- mount /dev/vda1 /home/mic

#Version 6-7
nsenter --mount=/proc/1/ns/mnt -- mount /dev/vda1 /home/mic
