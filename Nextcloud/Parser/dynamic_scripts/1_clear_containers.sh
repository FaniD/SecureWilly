#!/bin/sh

set -e

docker volume prune -f
docker-compose rm -vf
docker container prune -f
sudo rm data/*

