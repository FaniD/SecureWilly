#!/bin/sh

docker run --security-opt "apparmor=server_profile" --name dc-server --net caching_network -d cloudsuite/data-caching:server -t 4 -m 4096 -n 550
docker run --security-opt "apparmor=client_profile" -it --name dc-client --net caching_network -v /home/ubuntu/SecureWilly/Dynamic_Analysis/data-caching/Parser/dynamic_scripts/clientstask.sh:/clientstask.sh cloudsuite/data-caching:client ./clientstask.sh
