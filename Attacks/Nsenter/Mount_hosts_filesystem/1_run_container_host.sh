#!/bin/sh

#Build and run docker image
docker run --rm --name attacked_nsenter --security-opt "apparmor=attacked_container_profile" -t -i ubuntu:latest /bin/bash

