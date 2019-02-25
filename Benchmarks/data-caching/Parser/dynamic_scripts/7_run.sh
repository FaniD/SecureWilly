#!/bin/bash
 
docker run --name dc-server --net caching_network -d --security-opt "apparmor=cloudsuitedata-cachingserver_profile" cloudsuite/data-caching:server -t 4 -m 4096 -n 550
docker run -t --name dc-client --net caching_network -v /home/ubuntu/SecureWilly/Dynamic_Analysis/data-caching/scripts:/scripts --security-opt "apparmor=cloudsuitedata-cachingclient_profile" cloudsuite/data-caching:client ./scripts/clientstask.sh

docker stop dc-server
