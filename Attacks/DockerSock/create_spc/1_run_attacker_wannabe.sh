#!/bin/sh

docker build . -t spc_example
docker run --rm -it --security-opt "apparmor=spc_attacker" -v /var/run/docker.sock:/var/run/docker.sock spc_example

