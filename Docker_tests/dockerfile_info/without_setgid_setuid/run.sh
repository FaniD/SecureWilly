#!/bin/sh
docker build -t test .
docker run --security-opt "apparmor=missing_caps" -t -i test
