#!/bin/sh
#And now run the container

#If you want to do it through a script - create.sh - then use docker compose

#If you want to mount it manually and test it use docker run
docker build -t simply .
docker run -v /home/ubuntu/Security-on-Docker/Docker_tests/mount/simple_mount/data:/mount_here: -t -i simply:latest
