#!/bin/bash

#Read version of profile
read version
#For every service in the list below, cp the profile produced and move it in apparmor profiles directory
service_list=(nextcloudpi)
for SERVICE in "${service_list[@]}"; do
	sudo cp ../parser_output/profiles/${SERVICE}/version_${version} /etc/apparmor.d/
	sudo mv /etc/apparmor.d/version_${version} /etc/apparmor.d/${SERVICE}_profile
done
