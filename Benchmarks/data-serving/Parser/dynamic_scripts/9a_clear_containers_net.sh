#!/bin/bash

net=true
#delete network
if $net ; then
	docker network rm serving_network
fi

container_list=(db nextcloud)
for cont in "${container_list[@]}"; do
	docker container rm ${cont}
done
