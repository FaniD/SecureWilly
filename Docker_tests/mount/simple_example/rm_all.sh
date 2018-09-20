#!/bin/sh

rm df
rm mountinfo
rm data/*

# Delete all containers
docker rm $(docker ps -a -q)
# Delete all images
docker rmi $(docker images -q)
