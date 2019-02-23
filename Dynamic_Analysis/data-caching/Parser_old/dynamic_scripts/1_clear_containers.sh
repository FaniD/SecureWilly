#!/bin/sh
docker network rm caching_network
docker container rm dc-server
docker container rm dc-client

