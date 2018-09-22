#!/bin/sh

#Build and run docker image
docker build . -t mo

#Version 1 Worked
#docker run --privileged --security-opt "apparmor=mount_profile" -v /home/ubuntu/Security-on-Docker/Docker_tests/mount/simple_example/data:/mount_here -t -i mo:latest

#Version 2 Worked -> Run like version 1 but differs at container side: mkdir /tmpmount without -p flag

#Version 3 Worked -> Run with Dockerfile as V1, mount_profile, omitt -v and no privileged flag. nsenter for all mounts from the host
#docker run --security-opt "apparmor=mount_profile" -t -i mo:latest #-v /home/ubuntu/Security-on-Docker/Docker_tests/mount/simple_example/data:/mount_here -t -i mo:latest

#Version 4 -> Like version 3 but everything should be done from host side. Nothing on container side. Plain mount profile. Delete all rules
docker run --security-opt "apparmor=mount_profile" -t -i mo:latest
