#!/bin/sh

docker build . -t remount_umount

#In this example volume is not read-only so you can write with container to this fs
#docker run -v /home/ubuntu/Security-on-Docker/Docker_tests/mount/ro_volumes/data:/mount_here -t -i ro_vol:latest

#In this example volume is !!read-only!! so you cannot write with container to this fs
#docker run --security-opt "apparmor=ro_vol" -v /home/ubuntu/Security-on-Docker/Docker_tests/mount/ro_volumes/data:/mount_here:ro -t -i ro_vol:latest

#docker run -e HM=hmmm -v /home/ubuntu/Security-on-Docker/Docker_tests/mount/ro_volumes/data:/mount_here:ro -t -i ro_vol:latest


docker run --security-opt "apparmor=remount_umount" -t -i remount_umount:latest
