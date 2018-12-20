#!/bin/sh

docker build . -t docker_socket_attack

docker run --rm -it --security-opt "apparmor=socket_attacker" -v /var/run/docker.sock:/var/run/docker.sock docker_socket_attack

