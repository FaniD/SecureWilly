#!/bin/bash

read version
mkdir Logs2

#Save all logs in files
sudo cat /var/log/kern.log > Logs2/kernlogs_$version
chmod 777 Logs2/kernlogs_$version
sudo dmesg > Logs2/dmesg_$version
sudo cat /var/log/syslog > Logs2/syslogs_$version

