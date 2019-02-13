#!/bin/sh

net=false
#delete network
if $net ; then
	docker network rm streaming_network
fi
#docker container kill streaming_server
docker container rm streaming_dataset
docker container rm streaming_server
docker container rm streaming_client

