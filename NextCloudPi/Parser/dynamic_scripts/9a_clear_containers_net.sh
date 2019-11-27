#!/bin/bash

net=false
#delete network
if $net ; then
	docker network rm streaming_network
fi

container_list=(nextcloudpi)
for cont in "${container_list[@]}"; do
	docker container rm ${cont}
done
