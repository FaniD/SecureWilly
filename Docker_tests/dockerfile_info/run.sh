#!/bin/sh
docker build -t test .
docker run --security-opt "apparmor=static_profile" -t -i test
