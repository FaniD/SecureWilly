#!/bin/sh

#!/usr/bin/env bash
# Based on https://github.com/jenkinsci/docker/issues/196#issuecomment-179486312

DOCKER_SOCKET=/var/run/docker.sock
DOCKER_GROUP=docker
REGULAR_USER=userA

if [ -S ${DOCKER_SOCKET} ]; then
	DOCKER_GID=$(stat -c '%g' ${DOCKER_SOCKET})

	exists=$(cat /etc/group | grep ${DOCKER_GROUP})
	if [ -z "$exists" ]; then
        #If group docker does not already exist
		groupadd -for -g ${DOCKER_GID} ${DOCKER_GROUP}
		usermod -aG ${DOCKER_GROUP} ${REGULAR_USER}
	else 
	#If docker group exists
		groupmod -g ${DOCKER_GID} ${DOCKER_GROUP}
		usermod -aG ${DOCKER_GROUP} ${REGULAR_USER}
	fi
fi
