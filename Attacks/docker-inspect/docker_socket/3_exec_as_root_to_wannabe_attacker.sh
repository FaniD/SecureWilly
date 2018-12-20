#!/bin/sh

docker ps | grep attacker > dockerps
cut -d' ' -f1 dockerps > containerid
container_id=$(cat containerid)

#docker exec -it -u 0 ${container_id} /bin/bash -c "./add_user_to_docker_group.sh"
docker exec -u 0 ${container_id} ./add_user_to_docker_group.sh

rm dockerps
rm containerid
