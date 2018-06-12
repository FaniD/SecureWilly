#!/bin/bash

mkdir Logs

#Save all logs in files
sudo cat /var/log/kern.log > Logs/kernlogs_all
chmod 777 Logs/kernlogs_all
sudo dmesg > Logs/dmesg_all

#Then separate them for each service/profile
for SERVICE in server client dataset; do
	cat Logs/kernlogs_all | grep "${SERVICE}" > Logs/kernlogs_${SERVICE}
	cat Logs/dmesg_all | grep "${SERVICE}" > Logs/dmesg_${SERVICE}
done

