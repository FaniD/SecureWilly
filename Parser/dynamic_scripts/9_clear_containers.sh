#!/bin/sh

net=true
#delete network
if $net ; then
	docker network rm docker
fi
docker container rm streaming_dataset
docker container rm streaming_server
docker container rm streaming_client

