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

set -e

# Cleanup
echo "Clean containers"
docker container prune -f

echo "Docker-compose clean volumes"
docker-compose rm -vf

echo "Prune volumes"
docker volume prune -f

#docker container rm streaming_server
#docker container rm streaming_client

