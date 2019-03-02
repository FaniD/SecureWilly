#!/bin/bash

set -e

yml=false
if $yml ; then
	echo "Docker-compose clean volumes"
	docker-compose rm -vf
fi

