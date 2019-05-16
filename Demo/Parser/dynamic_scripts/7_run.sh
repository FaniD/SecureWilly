#!/bin/bash
 
docker build .. -t demo
docker run -d --cap-add SETUID -p "8887:8887" --pid=host --privileged --net=host -v "/etc:/etc" --security-opt "apparmor=demo_profile" --name demo demo
./curl_it.sh
docker kill demo
