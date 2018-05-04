#!/bin/bash

read version
mkdir Logs

#Save all logs in files
sudo cat /var/log/kern.log > Logs/kernlogs$version
chmod 777 Logs/kernlogs$version
sudo dmesg > Logs/dmesg$version

