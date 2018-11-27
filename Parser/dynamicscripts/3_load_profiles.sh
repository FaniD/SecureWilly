#!/bin/bash

service_list=(dataset server client)
for SERVICE in "${service_list[@]}"; do
	sudo apparmor_parser -r -W /etc/apparmor.d/${SERVICE}_profile
	sudo apparmor_parser -r -W /etc/apparmor.d/${SERVICE}_profile
	sudo apparmor_parser -r -W /etc/apparmor.d/${SERVICE}_profile
done
