#!/bin/sh

#Set profile to enforce mode
./set_profile.sh

#Build and run docker image
docker build . -t attack_vol3
docker run --security-opt "apparmor=attacked_container" -t -i attack_vol3:latest

