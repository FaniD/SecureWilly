#!/bin/bash

read version

#Save all logs in files
sudo cat /var/log/kern.log > Logs/kernlogs_$version
chmod 777 Logs/kernlogs_$version
sudo dmesg > Logs/dmesg_$version
sudo cat /var/log/syslog > Logs/syslogs_$version

