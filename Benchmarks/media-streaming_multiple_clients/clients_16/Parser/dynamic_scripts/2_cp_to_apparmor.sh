#!/bin/bash

#Read version of profile
read version
#For every service in the list below, cp the profile produced and move it in apparmor profiles directory
service_list=(cloudsuitemedia-streamingserver cloudsuitemedia-streamingclient1 cloudsuitemedia-streamingclient2 cloudsuitemedia-streamingclient3 cloudsuitemedia-streamingclient4 cloudsuitemedia-streamingclient5 cloudsuitemedia-streamingclient6 cloudsuitemedia-streamingclient7 cloudsuitemedia-streamingclient8 cloudsuitemedia-streamingclient9 cloudsuitemedia-streamingclient10 cloudsuitemedia-streamingclient11 cloudsuitemedia-streamingclient12 cloudsuitemedia-streamingclient13 cloudsuitemedia-streamingclient14 cloudsuitemedia-streamingclient15 cloudsuitemedia-streamingclient16 cloudsuitemedia-streamingdataset)
for SERVICE in "${service_list[@]}"; do
	sudo cp ../parser_output/profiles/${SERVICE}/version_${version} /etc/apparmor.d/
	sudo mv /etc/apparmor.d/version_${version} /etc/apparmor.d/${SERVICE}_profile
done
