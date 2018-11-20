#!/bin/sh
#And now run the container
docker build . -t ports
docker run -d -p "8887:8887" --security-opt "apparmor=ports_1" --name server ports

./curl_it.sh
