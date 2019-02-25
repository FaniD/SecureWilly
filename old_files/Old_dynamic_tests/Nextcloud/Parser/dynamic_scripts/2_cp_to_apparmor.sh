#!/bin/bash
read version
service_list=(nextcloud)
for SERVICE in "${service_list[@]}"; do
	sudo cp ../parser_output/profiles/${SERVICE}/version_${version} /etc/apparmor.d/
	sudo mv /etc/apparmor.d/version_${version} /etc/apparmor.d/${SERVICE}_profile
done
