#!/bin/bash

#read number_of_services
#read services
#for (( i=1; i<=${number_of_services}; i++ ))
#do
#	read service_${i}
#done 

#There is already a profile for each service by static_parser

#For each RUN follow the steps
#Starting with complain mode
i=1
while true; do
	./1_clear_containers.sh
	echo $i | source 2_cp_to_apparmor.sh
	./3_load_profiles.sh 
	./4a_complain_mode.sh
	./5_clear_logs.sh 
	./6_net.sh
	./7_run.sh
	./9_closing.sh
	echo ${i} | source 8_logging_files.sh
	echo ${i} 'complain' | source Logs/awk_it.sh
	break
	enforce_time=1
	for SERVICE in server client; do  #FIX THIS -> GENERIC
		python merge_profiles.py ${SERVICE} ${i} 'complain'
		echo ${SERVICE} ${i}+1 | source complain_enforce_audit.sh
		next_step=$(head -n 1 next_step_${SERVICE})
		if [ $next_step == '0' ]
		then
			$enforce_time=0
		fi
	done
	$i=$i+1
	if [ $enforce_time==1 ] #Then none of the services has 0 value so enforce time
	then
		break
	fi	
done
