#!/bin/sh

docker ps | grep attacker > dockerps
cut -d' ' -f1 dockerps > containerid
container_id=$(cat containerid)

docker exec -u 0 -it ${container_id} /bin/bash -c "./add_user_to_docker_group.sh"

rm dockerps
rm containerid
