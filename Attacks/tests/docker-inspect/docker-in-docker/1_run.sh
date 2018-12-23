#!/bin/sh

docker run --security-opt "apparmor=inspect_attack" -e Password=SuperSecretInfo -t -i ubuntu:latest

