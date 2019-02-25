#!/bin/sh

#If network is needed, is determined in API
net=true
if $net ; then
	docker network create serving_network
fi
