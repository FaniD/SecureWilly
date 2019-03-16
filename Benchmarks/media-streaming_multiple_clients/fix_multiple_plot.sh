#!/bin/bash

#Change this with the services I have each time
#Also do that in 2_cp, 3, 4a, 4b, 9, 10a, 10b, 12, metrics 

num="4"

service_list_noslash="(cloudsuitemedia-streamingserver "

#~~~~Fix range!!!
for i in `seq 1 4`; do
	service_list_noslash+="cloudsuitemedia-streamingclient${i} "
done
service_list_noslash+="cloudsuitemedia-streamingdataset)"
#Sed every script that needs them

#Dynamic parser seds alone because of its different path
sed -i "3s,service_list=(.*,service_list=${service_list_noslash}," clients_${num}/Parser/metrics/types_per_run.sh


