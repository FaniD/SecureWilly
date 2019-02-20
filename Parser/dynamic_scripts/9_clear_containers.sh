#!/bin/sh

net=true
#delete network
if $net ; then
	docker network rm docker
fi

service_list=(db test )
for SERVICE in "${service_list[@]}"; do
	docker container rm ${SERVICE} #streaming_dataset
done
	
#docker container rm streaming_server
#docker container rm streaming_client

