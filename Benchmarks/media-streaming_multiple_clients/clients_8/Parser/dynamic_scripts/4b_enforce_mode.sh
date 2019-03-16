#!/bin/bash
#If profiles are in complain mode, turn them in enforce mode

service_list=(cloudsuitemedia-streamingserver cloudsuitemedia-streamingclient1 cloudsuitemedia-streamingclient2 cloudsuitemedia-streamingclient3 cloudsuitemedia-streamingclient4 cloudsuitemedia-streamingdataset)
for SERVICE in "${service_list[@]}"; do
	sudo aa-enforce /etc/apparmor.d/${SERVICE}_profile
done
