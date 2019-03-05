#!/bin/sh
docker build -t dockerfile_example .
#docker run --security-opt "apparmor=dockerfile_info_profile" -t -i dockerfile_example

docker run -t -i dockerfile_example
