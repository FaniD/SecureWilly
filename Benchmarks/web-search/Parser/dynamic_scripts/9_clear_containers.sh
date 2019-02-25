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
	
set -e

# Cleanup
#echo "Clean containers"
#docker container prune -f

yml=false
if $yml ; then
	echo "Docker-compose clean volumes"
	docker-compose rm -vf
fi

echo "Prune volumes"
docker volume prune -f

