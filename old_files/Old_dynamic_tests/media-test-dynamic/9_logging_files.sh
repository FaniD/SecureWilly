#!/bin/bash

read round
#Save all logs in files
mkdir Logs/RUN${round}
sudo cat /var/log/kern.log > Logs/RUN${round}/kernlogs_all
chmod 777 Logs/RUN${round}/kernlogs_all
sudo dmesg > Logs/RUN${round}/dmesg_all

#Then separate them for each service/profile
for SERVICE in dataset server client; do
	cat Logs/RUN${round}/kernlogs_all | grep "${SERVICE}" > Logs/RUN${round}/kernlogs_${SERVICE}
	cat Logs/RUN${round}/dmesg_all | grep "${SERVICE}" > Logs/RUN${round}/dmesg_${SERVICE}
done

