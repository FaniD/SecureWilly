#!/bin/sh
docker network rm streaming_network
docker container kill streaming_server
docker container rm streaming_dataset
docker container rm streaming_server
docker container rm streaming_client

echo > /dev/null | sudo tee /var/log/syslog
echo > /dev/null | sudo tee /var/log/kern.log
