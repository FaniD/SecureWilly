#!/bin/bash
 
docker build -t dockerfile_info ..
docker run --name acont -t --security-opt "apparmor=dockerfile_info_profile" dockerfile_info
