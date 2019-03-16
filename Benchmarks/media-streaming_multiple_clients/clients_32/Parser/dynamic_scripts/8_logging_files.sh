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
service_list=(cloudsuitemedia-streamingserver cloudsuitemedia-streamingclient1 cloudsuitemedia-streamingclient2 cloudsuitemedia-streamingclient3 cloudsuitemedia-streamingclient4 cloudsuitemedia-streamingclient5 cloudsuitemedia-streamingclient6 cloudsuitemedia-streamingclient7 cloudsuitemedia-streamingclient8 cloudsuitemedia-streamingclient9 cloudsuitemedia-streamingclient10 cloudsuitemedia-streamingclient11 cloudsuitemedia-streamingclient12 cloudsuitemedia-streamingclient13 cloudsuitemedia-streamingclient14 cloudsuitemedia-streamingclient15 cloudsuitemedia-streamingclient16 cloudsuitemedia-streamingclient17 cloudsuitemedia-streamingclient18 cloudsuitemedia-streamingclient19 cloudsuitemedia-streamingclient20 cloudsuitemedia-streamingclient21 cloudsuitemedia-streamingclient22 cloudsuitemedia-streamingclient23 cloudsuitemedia-streamingclient24 cloudsuitemedia-streamingclient25 cloudsuitemedia-streamingclient26 cloudsuitemedia-streamingclient27 cloudsuitemedia-streamingclient28 cloudsuitemedia-streamingclient29 cloudsuitemedia-streamingclient30 cloudsuitemedia-streamingclient31 cloudsuitemedia-streamingclient32 cloudsuitemedia-streamingdataset)
for SERVICE in "${service_list[@]}"; do
	cat ../parser_output/Logs/RUN${round}/kernlogs_all | grep "${SERVICE}_profile" > ../parser_output/Logs/RUN${round}/kernlogs_${SERVICE}
	cat ../parser_output/Logs/RUN${round}/dmesg_all | grep "${SERVICE}_profile" > ../parser_output/Logs/RUN${round}/dmesg_${SERVICE}
done

