#!/bin/bash

net=true
#delete network
if $net ; then
	docker network rm streaming_network
fi

container_list=(streaming_server streaming_client1 streaming_client2 streaming_client3 streaming_client4 streaming_dataset)
for cont in "${container_list[@]}"; do
	docker container rm ${cont}
done
