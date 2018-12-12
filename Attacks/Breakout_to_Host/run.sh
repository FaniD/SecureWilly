#!/bin/sh

docker run --rm -it --security-opt "apparmor=attacker_profile" --pid=host --cap-add SYS_CHROOT --cap-add SYS_ADMIN --cap-add SYS_PTRACE debian:latest nsenter -t 1 -m sh


