#!/bin/bash

system_command="journalctl"
logs="audit"
if [[ $logs == "audit" ]]; then
  logfile="audit/audit.log" #kern.log
else
  logfile="kern.log"
fi

if [[ $system_command == "dmesg" ]]; then
  sudo dmesg --clear
else
  sudo journalctl --rotate
  sudo journalctl --vacuum-time=1s
fi

echo > /dev/null | sudo tee /var/log/${logfile}
