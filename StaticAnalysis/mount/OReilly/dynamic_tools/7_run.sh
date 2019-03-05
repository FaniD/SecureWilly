#!/bin/sh

docker run --rm -it --name=client --pid=host --cap-add NET_ADMIN --cap-add SYS_PTRACE --cap-add SYS_ADMIN --security-opt "apparmor=client_profile" debian:latest nsenter -t 1 -n sh

#Me auta ta capabilities to --pid=host einai pleon peritto
#docker run --rm -it --name=client --cap-add SYS_PTRACE --cap-add SYS_CHROOT --cap-add SYS_ADMIN --security-opt "apparmor=client_profile" debian:latest nsenter -t 1 -u -n -i sh
