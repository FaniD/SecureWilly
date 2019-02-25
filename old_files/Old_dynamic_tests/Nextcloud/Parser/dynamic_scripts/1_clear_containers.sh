#!/bin/sh

set -e

# Cleanup
echo "Clean containers"
docker container prune -f

echo "Docker-compose clean volumes"
docker-compose rm -vf

echo "Prune volumes"
docker volume prune -f
