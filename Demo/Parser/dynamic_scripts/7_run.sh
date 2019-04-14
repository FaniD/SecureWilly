#!/bin/bash
 
docker build .. -t demo
docker run -d -p "8887:8887" --pid=host --security-opt "apparmor=demo_profile" --name demo demo
./curl_it.sh
docker kill demo
