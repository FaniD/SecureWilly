#!/bin/bash

#Load the profiles into kernel
service_list=(db nextcloud)
for SERVICE in "${service_list[@]}"; do
	sudo cp ${SERVICE}_profile /etc/apparmor.d/
	sudo apparmor_parser -r -W /etc/apparmor.d/${SERVICE}_profile
done
