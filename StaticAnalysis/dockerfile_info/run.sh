#!/bin/sh
docker build -t test .
docker run --security-opt "apparmor=dockerinfo" -t -i test
