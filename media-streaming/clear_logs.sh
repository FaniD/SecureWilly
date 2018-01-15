#!/bin/sh

sudo dmesg --clear
echo > /dev/null | sudo tee /var/log/syslog
echo > /dev/null | sudo tee /var/log/kern.log
