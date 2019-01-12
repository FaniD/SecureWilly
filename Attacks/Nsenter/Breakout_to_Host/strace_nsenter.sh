#!/bin/sh

#Write profile to apparmor
sudo cp attacker_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/attacker_profile

docker run --rm -it --security-opt "apparmor=attacker_profile" --pid=host --cap-add SYS_PTRACE --cap-add SYS_ADMIN benhall/strace-ubuntu
#Inside the container run strace nsenter -t 1 -m ls /
#Returns nothing

