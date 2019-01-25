#!/bin/sh

#List the running containers and find the one that belongs to the attacker
docker ps | grep attacker > dockerps
#Keed the container id
cut -d' ' -f1 dockerps > containerid
container_id=$(cat containerid)

#Enter the running container as root and execute a script in it
docker exec -u 0 ${container_id} ./add_user_to_docker_group.sh

#Clear the files used
rm dockerps
rm containerid
