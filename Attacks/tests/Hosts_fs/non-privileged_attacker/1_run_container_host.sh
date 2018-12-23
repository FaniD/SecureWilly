#!/bin/sh

#Set profile to enforce mode
./attacked_container/set_profile.sh

#Build and run docker image
docker build attacked_container/ -t attacked_nsenter
docker run --cap-add MKNOD --security-opt "apparmor=attacked_container_profile" -t -i attacked_nsenter:latest

