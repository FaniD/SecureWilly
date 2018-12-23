#!/bin/sh

docker run --security-opt "apparmor=attacked" -e Password=SuperSecretInfo -t -i ubuntu:latest

