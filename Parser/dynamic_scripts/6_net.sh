#!/bin/sh

#If network is needed, is determined in API
net=false
if $net ; then
	docker network create streaming-network
fi
