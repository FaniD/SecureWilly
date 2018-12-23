#!/bin/sh

rm df
rm PID
rm mountinfo
rm restricted_area/*
rm data/*

# Delete all containers
docker rm $(docker ps -a -q)
# Delete all images
docker rmi $(docker images -q)
