#!/bin/bash
 
docker build -t dockerfile_info ..
docker run --name dockerfile_cont -it --security-opt "apparmor=dockerfile_info_profile" dockerfile_info
