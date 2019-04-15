#!/bin/bash

#Fix path of git repository

#Read absolute path
path=$(pwd)

#Replace /home/ubuntu with the approapriate dir
file_list=(test_plan.sh docker-compose.yml input_sample)
for file in "${file_list[@]}"; do
	sed -i "s,/home/ubuntu/SecureWilly/Nextcloud,${path},g" ${file}
done

#prof_list=(nextcloud_profile db_profile)
#for prof in "${prof_list[@]}"; do
#        sed -i "s,nextcloud_db_,apparmoroverhead_db_,g" ${prof}
#	sed -i "s,nextcloud_db_,apparmoroverhead_nextcloud_,g" ${prof}
#done
