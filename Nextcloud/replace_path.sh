#!/bin/bash

#Fix path of git repository

#Read absolute path
path=$(pwd)

#Replace /home/ubuntu with the approapriate dir
file_list=(docker-compose.yml) #input_sample for secure willy run
for file in "${file_list[@]}"; do
	sed -i "s,/home/ubuntu/SecureWilly/Nextcloud,${path},g" ${file}
done

prof_list=(db_profile nextcloud_profile)
for prof in "${prof_list[@]}"; do
        sed -i "s,/home/ubuntu/SecureWilly/Nextcloud,${path},g" parser_output/${prof}
	sudo cp parser_output/${prof} /etc/apparmor.d/
	sudo apparmor_parser -r -W /etc/apparmor.d/${prof}
done
