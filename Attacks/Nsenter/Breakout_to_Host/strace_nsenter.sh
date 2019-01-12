#!/bin/sh

#Write profile to apparmor
sudo cp attacker_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/attacker_profile
sudo aa-complain /etc/apparmor.d/attacker_profile

#Inside the container run strace nsenter -t 1 -m ls /
#Returns nothing
docker run --rm -it --security-opt "apparmor=attacker_profile" --pid=host --cap-add SYS_PTRACE --cap-add SYS_ADMIN myubuntu fani/strace-ubuntu

