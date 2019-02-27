#!/bin/bash

net=true
#delete network
if $net ; then
	docker network rm search_network
fi

container_list=(server client)
for cont in "${container_list[@]}"; do
	docker container rm ${cont}
done
