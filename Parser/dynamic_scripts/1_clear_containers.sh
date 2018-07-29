#!/bin/sh
docker network rm streaming_network
#docker container kill streaming_server
docker container rm streaming_dataset
docker container rm streaming_server
docker container rm streaming_client

