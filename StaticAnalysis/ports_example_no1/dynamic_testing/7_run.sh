#!/bin/sh
#And now run the container
docker build . -t ports
docker run -d -p "8887:8887" --security-opt "apparmor=server_profile" --name server ports

./curl_it.sh
