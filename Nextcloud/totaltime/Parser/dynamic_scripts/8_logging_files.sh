#!/bin/bash

read round

# Save all logs in files
system_command="journalctl"
logs="audit"
if [[ $logs == "audit" ]]; then
  logfile="audit/audit.log" #kern.log
else
  logfile="kern.log"
fi

#Create directories for logs for each run
mkdir ../parser_output/Logs/RUN${round}

#Create logs
sudo cat /var/log/${logfile} > ../parser_output/Logs/RUN${round}/${logs}_all
chmod 777 ../parser_output/Logs/RUN${round}/${logs}_all
sudo ${system_command} > ../parser_output/Logs/RUN${round}/${system_command}_all

# Then separate them for each service/profile
service_list=(db nextcloud)
for SERVICE in "${service_list[@]}"; do
  cat ../parser_output/Logs/RUN${round}/${logs}_all | grep "${SERVICE}_profile" > ../parser_output/Logs/RUN${round}/${logs}_${SERVICE}
  cat ../parser_output/Logs/RUN${round}/${system_command}_all | grep "${SERVICE}_profile" > ../parser_output/Logs/RUN${round}/${system_command}_${SERVICE}
done

