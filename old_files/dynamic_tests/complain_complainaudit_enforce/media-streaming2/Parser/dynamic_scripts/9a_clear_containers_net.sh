#!/bin/bash

net=true
#delete network
if $net ; then
	docker network rm streaming_network
fi

container_list=(streaming_server streaming_client streaming_dataset)
for cont in "${container_list[@]}"; do
	docker container rm ${cont}
done
