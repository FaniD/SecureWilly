#!/bin/bash

#First of all a task that has to be done is aborting network rule if we're about to use dynamic analysis.
#Network is added at static analysis but at that moment there we cannot be specific about the domain, type and protocol of networking.
#So network rule is added plain in order to make a usable profile even if our analysis is not completed.
#However, if we proceed to dynamic analysis, we have to abort network plain rule because we can now be specific about the networking.
#It cannot be aborted by its own because there will be no duplicate rule. So we abort it manually, if it is already in our profile.

for SERVICE in dataset server client; do  #FIX THIS -> GENERIC
	python abort_network_rule.py $SERVICE
done


./0_pull_images.sh

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
	./8_closing.sh
	echo $i | source 9_logging_files.sh
	echo $i | source 10a_awk_it_complain.sh
	x=${x:-$i}
	((x++))
	for SERVICE in dataset server client; do  #FIX THIS -> GENERIC
		python 11_merge_profiles.py $SERVICE $i 'complain'
	done
	echo $x | source 12_complain_enforce_audit.sh
	enforce_time='1'
	for SERVICE in dataset server client; do
		next_step=$(head -n 1 next_step_${SERVICE})
		#echo "Next step for ${SERVICE} is $next_step"
		if [ $next_step == '0' ]
		then
			enforce_time='0'
		fi
	done
	((i++))
	if [ $enforce_time == '1' ] #Then none of the services has 0 value so enforce time
	then
		#echo "Inside enforce time = ${enforce_time}"
		break
	fi	
done

while true; do
	./1_clear_containers.sh
	echo $i | source 2_cp_to_apparmor.sh
	./3_load_profiles.sh
	./4b_enforce_mode.sh
	./5_clear_logs.sh
	./6_net.sh
	./7_run.sh
	./8_closing.sh
	echo $i | source 9_logging_files.sh
	echo $i | source 10b_awk_it_enforce.sh
	x=${x:-$i}
	((x++))
	for SERVICE in dataset server client; do  #FIX THIS -> GENERIC
		python 11_merge_profiles.py $SERVICE $i 'enforce'
	done
	echo $x | source 12_complain_enforce_audit.sh
	audit_time='1'
	for SERVICE in dataset server client; do
		next_step=$(head -n 1 next_step_${SERVICE})
		#echo "Next step for ${SERVICE} is $next_step"
		if [ $next_step == '0' ]
		then
			audit_time='0'
		fi
	done
	((i++))
	if [ $audit_time == '1' ] #Then none of the services has 0 value so audit time
	then
		break
	fi
done

#Audit flag runs (complain & enforce) I need globbing.py otherwise we'll have an infinite loop because of every new instance

y=${y:-$i}
#while true; do

	./1_clear_containers.sh
	if [ $y == $i ] 
	then
		for SERVICE in dataset server client; do  #FIX THIS -> GENERIC
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
	for SERVICE in dataset server client; do  #FIX THIS -> GENERIC
		python 11_merge_profiles.py $SERVICE $i 'complain'
	done
#	echo $x | source 12_complain_enforce_audit.sh
#	audit_enforce_time='1'
#	for SERVICE in dataset server client; do
#		next_step=$(head -n 1 next_step_${SERVICE})
#		if [ $next_step == '0' ]
#		then
#			audit_enforce_time='0'
#		fi
#	done
	((i++))
#	if [ $audit_enforce_time == '1' ] #Then none of the services has 0 value so audit enforce time
#	then
#		break
#	fi
#done


#while true; do
	./1_clear_containers.sh
	echo $i | source 2_cp_to_apparmor.sh
        ./3_load_profiles.sh
	./4b_enforce_mode.sh
	./5_clear_logs.sh
	./6_net.sh
	./7_run.sh
        ./8_closing.sh
	echo $i | source 9_logging_files.sh
	echo $i | source 10b_awk_it_enforce.sh
	x=${x:-$i}
        ((x++))
	for SERVICE in dataset server client; do  #FIX THIS -> GENERIC
		python 11_merge_profiles.py $SERVICE $i 'enforce'
        done
#	echo $x | source 12_complain_enforce_audit.sh
#	end_of_logs='1'
#	for SERVICE in dataset server client; do
#		next_step=$(head -n 1 next_step_${SERVICE})
#	        #echo "Next step for ${SERVICE} is $next_step"
#	        if [ $next_step == '0' ]
#	        then
#		        end_of_logs='0'
#		fi
#	done
	((i++))
#	if [ $end_of_logs == '1' ] #Then none of the services has 0 value so audit time
#	then
#	        break
#	fi
#done

#version_{i} is the last profile
#Delete audit flag now
for SERVICE in dataset server client; do  #FIX THIS -> GENERIC
	python 13_delete_audit_flag.py $SERVICE $i
done
