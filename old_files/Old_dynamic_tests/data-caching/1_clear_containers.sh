#!/bin/sh
docker network rm caching_network
docker rm dc-client
docker rm dc-server
