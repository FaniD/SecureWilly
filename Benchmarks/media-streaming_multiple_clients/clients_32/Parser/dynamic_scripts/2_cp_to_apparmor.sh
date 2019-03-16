#!/bin/bash

#Read version of profile
read version
#For every service in the list below, cp the profile produced and move it in apparmor profiles directory
service_list=(cloudsuitemedia-streamingserver cloudsuitemedia-streamingclient1 cloudsuitemedia-streamingclient2 cloudsuitemedia-streamingclient3 cloudsuitemedia-streamingclient4 cloudsuitemedia-streamingclient5 cloudsuitemedia-streamingclient6 cloudsuitemedia-streamingclient7 cloudsuitemedia-streamingclient8 cloudsuitemedia-streamingclient9 cloudsuitemedia-streamingclient10 cloudsuitemedia-streamingclient11 cloudsuitemedia-streamingclient12 cloudsuitemedia-streamingclient13 cloudsuitemedia-streamingclient14 cloudsuitemedia-streamingclient15 cloudsuitemedia-streamingclient16 cloudsuitemedia-streamingclient17 cloudsuitemedia-streamingclient18 cloudsuitemedia-streamingclient19 cloudsuitemedia-streamingclient20 cloudsuitemedia-streamingclient21 cloudsuitemedia-streamingclient22 cloudsuitemedia-streamingclient23 cloudsuitemedia-streamingclient24 cloudsuitemedia-streamingclient25 cloudsuitemedia-streamingclient26 cloudsuitemedia-streamingclient27 cloudsuitemedia-streamingclient28 cloudsuitemedia-streamingclient29 cloudsuitemedia-streamingclient30 cloudsuitemedia-streamingclient31 cloudsuitemedia-streamingclient32 cloudsuitemedia-streamingdataset)
for SERVICE in "${service_list[@]}"; do
	sudo cp ../parser_output/profiles/${SERVICE}/version_${version} /etc/apparmor.d/
	sudo mv /etc/apparmor.d/version_${version} /etc/apparmor.d/${SERVICE}_profile
done
