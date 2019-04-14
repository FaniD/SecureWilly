#!/bin/bash

#Fix path of git repository

#Read absolute path
path=$(pwd)

#Replace /home/ubuntu with the approapriate dir
file_list=(genprof_run.sh docker-compose.yml)
for file in "${file_list[@]}"; do
	sed -i "s,/home/ubuntu/SecureWilly/Nextcloud,${path},g" ${file}
done
