#!/bin/sh

docker build . -t ro_vol

#In this example volume is not read-only so you can write with container to this fs
#docker run -v /home/ubuntu/Security-on-Docker/Docker_tests/mount/ro_volumes/data:/data -t -i ro_vol:latest

#In this example volume is !!read-only!! so you cannot write with container to this fs
docker run -e HM=hmmm -v /home/ubuntu/Security-on-Docker/Docker_tests/mount/ro_volumes/data:/data:ro -t -i ro_vol:latest
