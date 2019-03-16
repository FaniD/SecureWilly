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
service_list=(cloudsuitemedia-streamingserver cloudsuitemedia-streamingclient1 cloudsuitemedia-streamingclient2 cloudsuitemedia-streamingclient3 cloudsuitemedia-streamingclient4 cloudsuitemedia-streamingclient5 cloudsuitemedia-streamingclient6 cloudsuitemedia-streamingclient7 cloudsuitemedia-streamingclient8 cloudsuitemedia-streamingclient9 cloudsuitemedia-streamingclient10 cloudsuitemedia-streamingclient11 cloudsuitemedia-streamingclient12 cloudsuitemedia-streamingclient13 cloudsuitemedia-streamingclient14 cloudsuitemedia-streamingclient15 cloudsuitemedia-streamingclient16 cloudsuitemedia-streamingclient17 cloudsuitemedia-streamingclient18 cloudsuitemedia-streamingclient19 cloudsuitemedia-streamingclient20 cloudsuitemedia-streamingclient21 cloudsuitemedia-streamingclient22 cloudsuitemedia-streamingclient23 cloudsuitemedia-streamingclient24 cloudsuitemedia-streamingclient25 cloudsuitemedia-streamingclient26 cloudsuitemedia-streamingclient27 cloudsuitemedia-streamingclient28 cloudsuitemedia-streamingclient29 cloudsuitemedia-streamingclient30 cloudsuitemedia-streamingclient31 cloudsuitemedia-streamingclient32 cloudsuitemedia-streamingclient33 cloudsuitemedia-streamingclient34 cloudsuitemedia-streamingclient35 cloudsuitemedia-streamingclient36 cloudsuitemedia-streamingclient37 cloudsuitemedia-streamingclient38 cloudsuitemedia-streamingclient39 cloudsuitemedia-streamingclient40 cloudsuitemedia-streamingclient41 cloudsuitemedia-streamingclient42 cloudsuitemedia-streamingclient43 cloudsuitemedia-streamingclient44 cloudsuitemedia-streamingclient45 cloudsuitemedia-streamingclient46 cloudsuitemedia-streamingclient47 cloudsuitemedia-streamingclient48 cloudsuitemedia-streamingclient49 cloudsuitemedia-streamingclient50 cloudsuitemedia-streamingclient51 cloudsuitemedia-streamingclient52 cloudsuitemedia-streamingclient53 cloudsuitemedia-streamingclient54 cloudsuitemedia-streamingclient55 cloudsuitemedia-streamingclient56 cloudsuitemedia-streamingclient57 cloudsuitemedia-streamingclient58 cloudsuitemedia-streamingclient59 cloudsuitemedia-streamingclient60 cloudsuitemedia-streamingclient61 cloudsuitemedia-streamingclient62 cloudsuitemedia-streamingclient63 cloudsuitemedia-streamingclient64 cloudsuitemedia-streamingdataset)
for SERVICE in "${service_list[@]}"; do
	cat ../parser_output/Logs/RUN${round}/kernlogs_all | grep "${SERVICE}_profile" > ../parser_output/Logs/RUN${round}/kernlogs_${SERVICE}
	cat ../parser_output/Logs/RUN${round}/dmesg_all | grep "${SERVICE}_profile" > ../parser_output/Logs/RUN${round}/dmesg_${SERVICE}
done

