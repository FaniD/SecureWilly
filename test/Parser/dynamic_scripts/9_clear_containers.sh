#!/bin/sh

net=false
#delete network
if $net ; then
	docker network rm streaming_network
fi

#service_list=(cloudsuite/media-streaming:server cloudsuite/media-streaming:client)
#for SERVICE in "${service_list[@]}"; do
#	docker container rm ${SERVICE} #streaming_dataset
#done
	
#docker container rm streaming_server
#docker container rm streaming_client

set -e

# Cleanup
echo "Clean containers"
docker container prune -f

echo "Docker-compose clean volumes"
docker-compose rm -vf

echo "Prune volumes"
docker volume prune -f

