#!/bin/sh

#!/usr/bin/env bash
# Based on https://github.com/jenkinsci/docker/issues/196#issuecomment-179486312

DOCKER_SOCKET=/var/run/docker.sock
DOCKER_GROUP=docker
REGULAR_USER=userA

#If docker.sock exists
if [ -S ${DOCKER_SOCKET} ]; then
	#Find the GID of docker.sock
	DOCKER_GID=$(stat -c '%g' ${DOCKER_SOCKET})

	#Check if docker group exists
	exists=$(cat /etc/group | grep ${DOCKER_GROUP})
	if [ -z "$exists" ]; then
        #If group docker does not already exist
		#create group with the given gid and name
		groupadd -for -g ${DOCKER_GID} ${DOCKER_GROUP}
		#Modify user's group so as docker group is added
		usermod -aG ${DOCKER_GROUP} ${REGULAR_USER}
	else 
	#If docker group exists
		#Modify docker group so as to have the given id and name
		groupmod -g ${DOCKER_GID} ${DOCKER_GROUP}
		#Modify user's group so as docker group is added
		usermod -aG ${DOCKER_GROUP} ${REGULAR_USER}
	fi
fi
