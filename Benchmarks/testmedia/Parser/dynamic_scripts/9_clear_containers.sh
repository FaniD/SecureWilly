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
	
set -e

# Cleanup
#echo "Clean containers"
#docker container prune -f

yml=true
if $yml ; then
	echo "Docker-compose clean volumes"
	docker-compose rm -vf
fi

echo "Prune volumes"
docker volume prune -f

