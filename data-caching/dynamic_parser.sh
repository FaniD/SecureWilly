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
	echo $i | source 8_logging_files.sh
	echo $i | source awk_it_complain.sh
#	enforce_time=1
	x=${x:-$i}
	((x++))
	for SERVICE in server client; do  #FIX THIS -> GENERIC
		python merge_profiles.py $SERVICE $i 'complain'
	done
	#echo $SERVICE $x | source complain_enforce_audit.sh
	echo $x | source complain_enforce_audit.sh
	enforce_time='1'
	for SERVICE in server client; do
		next_step=$(head -n 1 next_step_${SERVICE})
		echo "Next step for ${SERVICE} is $next_step"
		if [ $next_step == '0' ]
		then
			enforce_time='0'
#			echo "enforce time = ${enforce_time}"
		fi
	done
	((i++))
#	echo "enforce time = ${enforce_time}"
	if [ $enforce_time == '1' ] #Then none of the services has 0 value so enforce time
	then
#		echo "Inside enforce time = ${enforce_time}"
#		echo "Enters here?"
		break
	fi	
done
