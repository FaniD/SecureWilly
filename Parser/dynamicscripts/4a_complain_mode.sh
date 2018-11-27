#!/bin/sh

service_list=(dataset server client)
for SERVICE in "${service_list[@]}"; do
	sudo aa-complain /etc/apparmor.d/${SERVICE}_profile
	sudo aa-complain /etc/apparmor.d/${SERVICE}_profile
	sudo aa-complain /etc/apparmor.d/${SERVICE}_profile
done
