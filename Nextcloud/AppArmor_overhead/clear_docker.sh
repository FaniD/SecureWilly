#!/bin/bash

docker network rm apparmoroverhead_default

container_list=(db nextcloud)
for cont in "${container_list[@]}"; do
	docker container rm ${cont}
done

set -e

docker volume prune -f
