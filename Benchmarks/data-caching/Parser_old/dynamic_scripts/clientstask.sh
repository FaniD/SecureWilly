#!/bin/bash

#Inside client's container:

#Prepare client
cd /usr/src/memcached/memcached_client/
rm docker_servers.txt
echo "dc-server, 11211" > docker_servers.txt

#Create datashet
./loader -a ../twitter_dataset/twitter_dataset_unscaled -o ../twitter_dataset/twitter_dataset_30x -s docker_servers.txt -w 4 -S 30 -D 4096 -j -T 1

#Warm up server
./loader -a ../twitter_dataset/twitter_dataset_30x -s docker_servers.txt -w 4 -S 1 -D 4096 -j -T 1

#Run benchmark
#Maximum throughput
./loader -a ../twitter_dataset/twitter_dataset_30x -s docker_servers.txt -g 0.8 -T 1 -c 200 -w 8
#rps 90%
./loader -a ../twitter_dataset/twitter_dataset_30x -s docker_servers.txt -g 0.8 -T 1 -c 200 -w 8 -e -r rps

