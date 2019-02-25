#!/bin/bash

#Set the profile of each service to complain mode
service_list=(cloudsuitemedia-streamingserver cloudsuitemedia-streamingclient)
for SERVICE in "${service_list[@]}"; do
	sudo aa-complain /etc/apparmor.d/${SERVICE}_profile
done
