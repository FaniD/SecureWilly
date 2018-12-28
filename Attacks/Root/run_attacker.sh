#!/bin/sh

docker build . -t root_attack

#root
docker run --rm -it -v /etc:/etc root_attack
#docker run --rm -it --security-opt "apparmor=root_attacker" -v /etc:/etc root_attack

#user
#docker run -u 555 --rm -it -v /etc:/etc root_attack
#docker run -u 555 --rm -it --security-opt "apparmor=root_attacker" -v /etc:/etc root_attack

