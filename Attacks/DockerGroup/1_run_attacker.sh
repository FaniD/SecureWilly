#!/bin/sh

#chmod a+s: a:all users, +s:If someone else runs the file, they will run the file as the user/group who created it.
docker build . -t docgroup
docker run --rm -it --security-opt "apparmor=attacker_profile" -v /bin/:/attack_bin docgroup

