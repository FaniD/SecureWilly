#!/bin/bash

net=true
#delete network
if $net ; then
	docker network rm caching_network
fi

container_list=(dc-server dc-client)
for cont in "${container_list[@]}"; do
	docker container rm ${cont}
done
