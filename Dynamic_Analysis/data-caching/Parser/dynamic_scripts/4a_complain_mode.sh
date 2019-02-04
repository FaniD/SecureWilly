#!/bin/bash

service_list=(server client)
for SERVICE in "${service_list[@]}"; do
	sudo aa-complain /etc/apparmor.d/${SERVICE}_profile
done
