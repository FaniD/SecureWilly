#!/bin/sh

docker run --rm -it --name=client --cap-add SYS_ADMIN --cap-add SYS_PTRACE --pid=host --security-opt "apparmor=client_profile" debian:latest nsenter -t 1 -m sh
