#!/bin/bash

read number_of_services
#read services
for (( i=1; i<=${number_of_services}; i++ ))
do
	read service_${i}
done 

#There is already a profile for each service by static_parser

#For each RUN follow the steps
#Starting with complain mode
i=1
while true; do
	./1_clear_containers.sh
	for (( x=1; x<=${number_of_services}; x++ ))
	do
		echo ${i} ${i} | source 2_cp_to_apparmor.sh
	done

	./3_load_profiles.sh 
	./4a_complain_mode.sh
	./5_clear_logs.sh 
	./6_net.sh
	./7_run.sh
	./9_closing.sh

	for (( x=1; x<=${number_of_services}; x++ ))
	do
		echo ${i} ${i} | source 2_cp_to_apparmor.sh
	done
	./8_logging_files.sh < $i
	./Logs/awk_it.sh < $i 'complain'
	

done
