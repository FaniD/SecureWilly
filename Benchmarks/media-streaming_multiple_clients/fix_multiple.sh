#!/bin/bash

#Change this with the services I have each time
#Also do that in 2_cp, 3, 4a, 4b, 9, 10a, 10b, 12, metrics 

num="16"

service_list_noslash="(cloudsuitemedia-streamingserver "

#~~~~Fix range!!!
for i in `seq 1 16`; do
	service_list_noslash+="cloudsuitemedia-streamingclient${i} "
	cp cloudsuitemedia-streamingclient_profile clients_${num}/parser_output/cloudsuitemedia-streamingclient${i}_profile
	sed -i "3s,client,client${i}," clients_${num}/parser_output/cloudsuitemedia-streamingclient${i}_profile
	cp if_vol_cloudsuitemedia-streamingclient clients_${num}/Parser/if_vol_cloudsuitemedia-streamingclient${i}
done
service_list_noslash+="cloudsuitemedia-streamingdataset)"
#Sed every script that needs them

#Dynamic parser seds alone because of its different path
sed -i "5s,service_list=(.*,service_list=${service_list_noslash}," clients_${num}/Parser/dynamic_parser.sh
file_list=(2_cp_to_apparmor.sh*6s 3_load_profiles.sh*4s 4a_complain_mode.sh*4s 4b_enforce_mode.sh*4s 8_logging_files.sh*15s 10a_awk_it_complain.sh*10s 10b_awk_it_enforce.sh*10s 12_complain_enforce_audit.sh*5s)
for f_i in  "${file_list[@]}"; do
	file_i=$(echo $f_i | cut -d'*' -f1)
	line=$(echo $f_i | cut -d'*' -f2) #line var includes s for sed
	sed -i "${line},service_list=(.*,service_list=${service_list_noslash}," clients_${num}/Parser/dynamic_scripts/${file_i}
done

cp 7_run.sh clients_${num}/Parser/dynamic_scripts/7_run.sh

j=7
for i in `seq 2 16`; do
	sed -i "${j}s,.*,docker run -t --name streaming_client${i} -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt "apparmor=cloudsuitemedia-streamingclient${i}_profile" cloudsuite/media-streaming:client streaming_server," clients_${num}/Parser/dynamic_scripts/7_run.sh
	((j++))
done

sed -i "${j}s,.*,docker stop streaming_server," clients_${num}/Parser/dynamic_scripts/7_run.sh

