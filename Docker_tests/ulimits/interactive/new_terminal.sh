#!/bin/sh

echo "Run docker ps and give me container id:"
read id
docker exec -ti ${id} /bin/bash
