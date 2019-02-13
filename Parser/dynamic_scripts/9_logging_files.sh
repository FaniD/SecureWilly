#!/bin/bash

read round
#Save all logs in files

#Create directories for logs for each run
mkdir ../parser_output/Logs/RUN${round}

#Create logs
sudo cat /var/log/kern.log > ../parser_output/Logs/RUN${round}/kernlogs_all
chmod 777 ../parser_output/Logs/RUN${round}/kernlogs_all
sudo dmesg > ../parser_output/Logs/RUN${round}/dmesg_all

#Then separate them for each service/profile
service_list=(service)
for SERVICE in "${service_list[@]}"; do
	cat ../parser_output/Logs/RUN${round}/kernlogs_all | grep "${SERVICE}" > ../parser_output/Logs/RUN${round}/kernlogs_${SERVICE}
	cat ../parser_output/Logs/RUN${round}/dmesg_all | grep "${SERVICE}" > ../parser_output/Logs/RUN${round}/dmesg_${SERVICE}
done

