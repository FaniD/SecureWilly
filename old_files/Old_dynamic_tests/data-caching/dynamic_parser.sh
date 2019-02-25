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
#i=1
#while true; do
#	./1_clear_containers.sh
#	echo $i | source 2_cp_to_apparmor.sh
#	./3_load_profiles.sh 
#	./4a_complain_mode.sh
#	./5_clear_logs.sh 
#	./6_net.sh
#	./7_run.sh
#	./8_closing.sh
#	echo $i | source 9_logging_files.sh
#	echo $i | source 10a_awk_it_complain.sh
#	x=${x:-$i}
#	((x++))
#	for SERVICE in server client; do  #FIX THIS -> GENERIC
#		python 11_merge_profiles.py $SERVICE $i 'complain'
#	done
#	echo $x | source 12_complain_enforce_audit.sh
#	enforce_time='1'
#	for SERVICE in server client; do
#		next_step=$(head -n 1 next_step_${SERVICE})
#		#echo "Next step for ${SERVICE} is $next_step"
#		if [ $next_step == '0' ]
#		then
#			enforce_time='0'
#		fi
#	done
#	((i++))
#	if [ $enforce_time == '1' ] #Then none of the services has 0 value so enforce time
#	then
#		#echo "Inside enforce time = ${enforce_time}"
#		break
#	fi	
#done
#i=5
#while true; do
#	./1_clear_containers.sh
#	echo $i | source 2_cp_to_apparmor.sh
#	./3_load_profiles.sh
#	./4b_enforce_mode.sh
#	./5_clear_logs.sh
#	./6_net.sh
#	./7_run.sh
#	./8_closing.sh
#	echo $i | source 9_logging_files.sh
#	echo $i | source 10b_awk_it_enforce.sh
#	x=${x:-$i}
#	((x++))
#	for SERVICE in server client; do  #FIX THIS -> GENERIC
#		python 11_merge_profiles.py $SERVICE $i 'enforce'
#	done
#	echo $x | source 12_complain_enforce_audit.sh
#	audit_time='1'
#	for SERVICE in server client; do
#		next_step=$(head -n 1 next_step_${SERVICE})
#		#echo "Next step for ${SERVICE} is $next_step"
#		if [ $next_step == '0' ]
#		then
#			audit_time='0'
#		fi
#	done
#	((i++))
#	if [ $audit_time == '1' ] #Then none of the services has 0 value so audit time
#	then
#		break
#	fi
#done

i=6
y=${y:-$i}
while true; do
	./1_clear_containers.sh
	if [ $y == $i ] 
	then
		for SERVICE in server client; do  #FIX THIS -> GENERIC
			python 2_pre_cp_audit_flag.py $SERVICE $i
		done
	fi
	echo $i | source 2_cp_to_apparmor.sh
	./3_load_profiles.sh
	./4a_complain_mode.sh
	./5_clear_logs.sh
	./6_net.sh
	./7_run.sh
	./8_closing.sh
	echo $i | source 9_logging_files.sh
	echo $i | source 10a_awk_it_complain.sh
	x=${x:-$i}
	((x++))
	for SERVICE in server client; do  #FIX THIS -> GENERIC
		python 11_merge_profiles.py $SERVICE $i 'complain'
	done
	echo $x | source 12_complain_enforce_audit.sh
	audit_enforce_time='1'
	for SERVICE in server client; do
		next_step=$(head -n 1 next_step_${SERVICE})
		if [ $next_step == '0' ]
		then
			audit_enforce_time='0'
		fi
	done
	((i++))
	if [ $audit_enforce_time == '1' ] #Then none of the services has 0 value so audit enforce time
	then
		break
	fi
done




