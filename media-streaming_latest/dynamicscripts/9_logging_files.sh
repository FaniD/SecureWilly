#!/bin/bash

read round
#Save all logs in files
mkdir ../parser_output/Logs/RUN${round}
sudo cat /var/log/kern.log > ../parser_output/Logs/RUN${round}/kernlogs_all
chmod 777 ../parser_output/Logs/RUN${round}/kernlogs_all
sudo dmesg > ../parser_output/Logs/RUN${round}/dmesg_all

#Then separate them for each service/profile

service_list=(dataset server client)
for SERVICE in "${service_list[@]}"; do
	cat ../parser_output/Logs/RUN${round}/kernlogs_all | grep "${SERVICE}" > ../parser_output/Logs/RUN${round}/kernlogs_${SERVICE}
	cat ../parser_output/Logs/RUN${round}/dmesg_all | grep "${SERVICE}" > ../parser_output/Logs/RUN${round}/dmesg_${SERVICE}
done

