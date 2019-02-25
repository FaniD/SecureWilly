#!/bin/bash

#Load the AppArmor profiles for services in the list below
service_list=(cloudsuitemedia-streamingserver cloudsuitemedia-streamingclient cloudsuitemedia-streamingdataset)
for SERVICE in "${service_list[@]}"; do
	sudo apparmor_parser -r -W /etc/apparmor.d/${SERVICE}_profile
done
