#!/bin/sh

#Clear logs
sudo dmesg --clear
echo > /dev/null | sudo tee /var/log/syslog
echo > /dev/null | sudo tee /var/log/kern.log

#Clear all docker filesystems/images/network etc
docker system prune -a
