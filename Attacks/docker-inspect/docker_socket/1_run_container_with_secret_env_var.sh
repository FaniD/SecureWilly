#!/bin/sh

docker run --name attacked_container --rm --security-opt "apparmor=socket_attacked" -e Password=SuperSecretPassword -t -i ubuntu:latest

