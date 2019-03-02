#!/bin/bash

set -e

yml=true
if $yml ; then
	echo "Docker-compose clean volumes"
	docker-compose rm -vf
fi

