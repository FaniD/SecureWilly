#!/bin/sh
docker run --name dc-server --net caching_network -d cloudsuite/data-caching:server -t 4 -m 4096 -n 550
docker run -it --name dc-client --net caching_network cloudsuite/data-caching:client bash

#Inside client's container:

#Prepare client
#cd /usr/src/memcached/memcached_client/
#vim docker_servers.txt
#dc-server, 11211

#Create datashet
#./loader -a ../twitter_dataset/twitter_dataset_unscaled -o ../twitter_dataset/twitter_dataset_30x -s docker_servers.txt -w 4 -S 30 -D 4096 -j -T 1

#Warm up server
#./loader -a ../twitter_dataset/twitter_dataset_30x -s docker_servers.txt -w 4 -S 1 -D 4096 -j -T 1

#Run benchmark
#Maximum throughput
#./loader -a ../twitter_dataset/twitter_dataset_30x -s docker_servers.txt -g 0.8 -T 1 -c 200 -w 8
#rps 90%
#./loader -a ../twitter_dataset/twitter_dataset_30x -s docker_servers.txt -g 0.8 -T 1 -c 200 -w 8 -e -r rps

#exit
#docker stop dc-server
