#!/bin/bash
#If profiles are in complain mode, turn them in enforce mode

service_list=(cloudsuitedata-servingserver cloudsuitedata-servingclient)
for SERVICE in "${service_list[@]}"; do
	sudo aa-enforce /etc/apparmor.d/${SERVICE}_profile
done
