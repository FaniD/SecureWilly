#!/bin/bash
 
docker run -d --name dc-server --net caching_network -d --security-opt "apparmor=cloudsuitedata-cachingserver_profile" cloudsuite/data-caching:server -t 4 -m 4096 -n 550
docker run -d -t --name dc-client --net caching_network -v /home/ubuntu/SecureWilly/Benchmarks/data-caching/scripts:/scripts --security-opt "apparmor=cloudsuitedata-cachingclient_profile" cloudsuite/data-caching:client bash
docker exec -t dc-client ./scripts/1_create_dataset.sh
docker exec -t dc-client ./scripts/2_run.sh
docker exec -t dc-client ./scripts/3_run.sh
docker stop dc-client
docker stop dc-server
