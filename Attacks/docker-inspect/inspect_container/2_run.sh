#!/bin/sh

docker run --rm -it --security-opt "apparmor=inspect_attacker" --pid=host --cap-add SYS_ADMIN --cap-add SYS_PTRACE debian:latest nsenter -t 1 -m /bin/bash


