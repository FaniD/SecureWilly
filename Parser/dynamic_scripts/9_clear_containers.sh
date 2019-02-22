#!/bin/sh

net=true
#delete network
if $net ; then
	docker network rm streaming-network
fi

service_list=(cloudsuite/media-streaming:server cloudsuite/media-streaming:client)
for SERVICE in "${service_list[@]}"; do
	docker container rm ${SERVICE} #streaming_dataset
done
	
#docker container rm streaming_server
#docker container rm streaming_client

