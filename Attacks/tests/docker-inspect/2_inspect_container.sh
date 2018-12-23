#!/bin/sh

docker ps | grep ubuntu > dockerps
cut -d' ' -f1 dockerps > containerid
container_id=$(cat containerid)
docker inspect ${container_id} > inspect_output
