#!/bin/sh

#Build and run docker image
docker build . -t mo

#Versions 1-4: Attack Host to Container

#Version 1 Worked
#docker run --privileged --security-opt "apparmor=mount_profile" -v /home/ubuntu/Security-on-Docker/Docker_tests/mount/attack_host_to_container/data:/mount_here -t -i mo:latest

#Version 2 Worked -> Run like version 1 but differs at container side: mkdir /tmpmount without -p flag

#Version 3 Worked -> Run with Dockerfile as V1, mount_profile, omitt -v and no privileged flag. nsenter for all mounts from the host
#docker run --security-opt "apparmor=mount_profile" -t -i mo:latest #-v /home/ubuntu/Security-on-Docker/Docker_tests/mount/simple_example/data:/mount_here -t -i mo:latest

#Version 4 -> Like version 3 but everything should be done from host side. Nothing on container side. Plain mount profile. Delete all rules
#docker run --security-opt "apparmor=mount_profile" -t -i mo:latest

#Versions 5-7: Attack Container to Host

#Version 5 run privileged without profile to see if I can nsenter host
#docker run --privileged -v /:/media/host -t -i mo:latest

#Version 6 run privileged with --pid=host to see if we can see host's mount namespace
#docker run --privileged --pid=host -t -i mo:latest

#Version 7 run non privileged with --pid=host try to do nsenter
#docker run --pid="host" -t -i mo:latest

#Version 8 run privileged with --pid=host and profile
#docker run --privileged --security-opt "apparmor=mount_profile" --pid=host -t -i mo:latest

#Version 9
#docker run --privileged --net=host --security-opt "apparmor=mount_profile" -v /:/media/host -t -i mo:latest

#Version 10
docker run  --cap-add=ALL --pid="host" --net="host" --ipc="host" --uts="host" -v /:/media/host -v /dev:/dev -v /run:/run --security-opt "apparmor=mount_profile" -t -i mo:latest
