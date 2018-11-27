#!/bin/sh
#If profiles are in complain mode, turn them in enforce mode

service_list=(dataset server client)
for SERVICE in "${service_list[@]}"; do
	sudo aa-enforce /etc/apparmor.d/${SERVICE}_profile
	sudo aa-enforce /etc/apparmor.d/${SERVICE}_profile
	sudo aa-enforce /etc/apparmor.d/${SERVICE}_profile
done
