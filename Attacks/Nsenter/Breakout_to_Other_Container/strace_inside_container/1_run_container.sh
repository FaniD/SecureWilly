#!/bin/sh

#Attack container
docker run --security-opt "apparmor=attacker_profile" --cap-add SYS_ADMIN --rm -it benhall/strace-ubuntu
