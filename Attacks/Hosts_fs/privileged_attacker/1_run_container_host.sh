#!/bin/sh

#Set profile to enforce mode
./attacked_container/set_profile.sh

#Build and run docker image
docker build attacked_container/ -t attack_vol3
docker run --cap-add MKNOD --security-opt "apparmor=attacked_container_profile" -t -i attack_vol3:latest

