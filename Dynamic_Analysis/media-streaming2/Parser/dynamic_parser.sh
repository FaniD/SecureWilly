#!/bin/bash

#Change this with the services I have each time
#Also do that in 2_cp, 3, 4a, 4b, 9, 10a, 10b, 12, metrics 
service_list=(cloudsuitemedia-streamingserver cloudsuitemedia-streamingclient)

app_run_path=".."
parser_path="${app_run_path}/Parser"
dynamic_script_path="${parser_path}/dynamic_scripts"

#Clear old files and output directories and create new
rm -r ${app_run_path}/parser_output/Logs
rm -r ${app_run_path}/parser_output/profiles

#If it does not exist
mkdir ${app_run_path}/parser_output

#If static analysis has been done, then we expect to see static profile in output directory. Count files in there to find out
ls ${app_run_path}/parser_output/ -1 | wc -l > s
static_part=$(head -n 1 s)
rm s

mkdir ${app_run_path}/parser_output/Logs
mkdir ${app_run_path}/parser_output/profiles

for SERVICE in "${service_list[@]}"; do
	sudo rm /etc/apparmor.d/${SERVICE}_profile
	mkdir ${app_run_path}/parser_output/profiles/${SERVICE}
	#If static profile exists, otherwise make this a comment and create it a simple version_1
	if [[ "$static_part" > "0" ]]; then
		mv ${app_run_path}/parser_output/${SERVICE}_profile ${app_run_path}/parser_output/profiles/${SERVICE}/version_1
	else
		python ${dynamic_script_path}/create_version_1.py ${SERVICE}
	fi
done

#First of all a task that has to be done is aborting network rule if we're about to use dynamic analysis.
#Network is added at static analysis but at that moment there we cannot be specific about the domain, type and protocol of networking.
#So network rule is added plain in order to make a usable profile even if our analysis is not completed.
#However, if we proceed to dynamic analysis, we have to abort network plain rule because we can now be specific about the networking.
#It cannot be aborted by its own because there will be no duplicate rule. So we abort it manually, if it is already in our profile.

for SERVICE in "${service_list[@]}"; do
	python ${dynamic_script_path}/1_abort_network_rule.py $SERVICE
done

#Pull images if there are on dockerhub and not locally
#./${dynamic_script_path}/0b_pull_images.sh


#For each RUN follow the steps
#Starting with complain mode
i=1
while true; do
	echo $i | source ${dynamic_script_path}/2_cp_to_apparmor.sh
	./${dynamic_script_path}/3_load_profiles.sh 
	./${dynamic_script_path}/4a_complain_mode.sh
	./${dynamic_script_path}/5_clear_logs.sh 

	#6. Ommit if there is no network to create
	./${dynamic_script_path}/6_net.sh

	./${dynamic_script_path}/7_run.sh
	echo $i | source ${dynamic_script_path}/8_logging_files.sh
	./${dynamic_script_path}/9_clear_containers.sh
	echo $i | source ${dynamic_script_path}/10a_awk_it_complain.sh
	x=${x:-$i}
	((x++))
	lp_count=0
	for SERVICE in "${service_list[@]}"; do
		vol_str=$(cut -d'%' -f1 if_vol_${SERVICE})
		num_vols=$(cut -d'%' -f2 if_vol_${SERVICE})
		if [[ "$num_vols" == "0" ]]; then
			sed -i "83s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "83s/.*/#&/" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "84s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "84s/.*/#&/" ${dynamic_script_path}/11_merge_profiles.py
		else
			sed -i "83s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "83s|if .*|if ${vol_str}|" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "84s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
		fi
		python ${dynamic_script_path}/11_merge_profiles.py $SERVICE $i 'complain'
		((lp_count++))
	done
	echo $x | source ${dynamic_script_path}/12_complain_enforce_audit.sh
	enforce_time='1'
	for SERVICE in "${service_list[@]}"; do
		next_step=$(head -n 1 next_step_${SERVICE})
		#echo "Next step for ${SERVICE} is $next_step"
		if [[ "$next_step" == "0" ]]
		then
			enforce_time="0"
		fi
	done
	((i++))
	if [[ "$enforce_time" == "1" ]] #Then none of the services has 0 value so enforce time
	then
		#echo "Inside enforce time = ${enforce_time}"
		break
	fi	
done

while true; do
	echo $i | source ${dynamic_script_path}/2_cp_to_apparmor.sh
	./${dynamic_script_path}/3_load_profiles.sh
	./${dynamic_script_path}/4b_enforce_mode.sh
	./${dynamic_script_path}/5_clear_logs.sh
	./${dynamic_script_path}/6_net.sh
	./${dynamic_script_path}/7_run.sh
	echo $i | source ${dynamic_script_path}/8_logging_files.sh
	./${dynamic_script_path}/9_clear_containers.sh
	echo $i | source ${dynamic_script_path}/10b_awk_it_enforce.sh
	x=${x:-$i}
	((x++))
	lp_count=0
	for SERVICE in "${service_list[@]}"; do 
		vol_str=$(cut -d'%' -f1 if_vol_${SERVICE})
		num_vols=$(cut -d'%' -f2 if_vol_${SERVICE})
		if [[ "$num_vols" == "0" ]]; then
			sed -i "83s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "83s/.*/#&/" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "84s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "84s/.*/#&/" ${dynamic_script_path}/11_merge_profiles.py
		else
			sed -i "83s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "83s|if .*|if ${vol_str}|" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "84s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
		fi
		python ${dynamic_script_path}/11_merge_profiles.py $SERVICE $i 'enforce'
		((lp_count++))
	done
	echo $x | source ${dynamic_script_path}/12_complain_enforce_audit.sh
	audit_time="1"
	for SERVICE in "${service_list[@]}"; do
		next_step=$(head -n 1 next_step_${SERVICE})
		#echo "Next step for ${SERVICE} is $next_step"
		if [[ "$next_step" == "0" ]]
		then
			audit_time="0"
		fi
	done
	((i++))
	if [[ "$audit_time" == "1" ]] #Then none of the services has 0 value so audit time
	then
		break
	fi
done

#Audit flag runs (complain & enforce)

y=${y:-$i}
#########################
while true; do
#########################
	if [ $y -eq $i ] 
	then
		for SERVICE in "${service_list[@]}"; do  
			python ${dynamic_script_path}/2_pre_cp_audit_flag.py $SERVICE $i
		done
	fi
	echo $i | source ${dynamic_script_path}/2_cp_to_apparmor.sh
	./${dynamic_script_path}/3_load_profiles.sh
	./${dynamic_script_path}/4a_complain_mode.sh
	./${dynamic_script_path}/5_clear_logs.sh
	./${dynamic_script_path}/6_net.sh
	./${dynamic_script_path}/7_run.sh
	echo $i | source ${dynamic_script_path}/8_logging_files.sh
	./${dynamic_script_path}/9_clear_containers.sh
	echo $i | source ${dynamic_script_path}/10a_awk_it_complain.sh
	x=${x:-$i}
	((x++))
	lp_count=0
	for SERVICE in "${service_list[@]}"; do
		vol_str=$(cut -d'%' -f1 if_vol_${SERVICE})
		num_vols=$(cut -d'%' -f2 if_vol_${SERVICE})
		if [[ "$num_vols" == "0" ]]; then
			sed -i "83s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "83s/.*/#&/" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "84s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "84s/.*/#&/" ${dynamic_script_path}/11_merge_profiles.py
		else
			sed -i "83s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "83s|if .*|if ${vol_str}|" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "84s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
		fi
		python ${dynamic_script_path}/11_merge_profiles.py $SERVICE $i 'complain'
		((lp_count++))
	done
####################
	echo $x | source ${dynamic_script_path}/12_complain_enforce_audit.sh
	audit_enforce_time="1"
	for SERVICE in "${service_list[@]}"; do
		next_step=$(head -n 1 next_step_${SERVICE})
		if [[ "$next_step" == "0" ]]
		then
			audit_enforce_time="0"
		fi
	done
###################
	((i++))
###################
	if [[ "$audit_enforce_time" == "1" ]] #Then none of the services has 0 value so audit enforce time
	then
		break
	fi
done
###################


while true; do
	echo $i | source ${dynamic_script_path}/2_cp_to_apparmor.sh
        ./${dynamic_script_path}/3_load_profiles.sh
	./${dynamic_script_path}/4b_enforce_mode.sh
	./${dynamic_script_path}/5_clear_logs.sh
	./${dynamic_script_path}/6_net.sh
	./${dynamic_script_path}/7_run.sh
	echo $i | source ${dynamic_script_path}/8_logging_files.sh
	./${dynamic_script_path}/9_clear_containers.sh
	echo $i | source ${dynamic_script_path}/10b_awk_it_enforce.sh
	x=${x:-$i}
        ((x++))
	lp_count++
	for SERVICE in "${service_list[@]}"; do
		vol_str=$(cut -d'%' -f1 if_vol_${SERVICE})
		num_vols=$(cut -d'%' -f2 if_vol_${SERVICE})
		if [[ "$num_vols" == "0" ]]; then
			sed -i "83s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "83s/.*/#&/" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "84s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "84s/.*/#&/" ${dynamic_script_path}/11_merge_profiles.py
		else
		        sed -i "83s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
		        sed -i "83s|if .*|if ${vol_str}|" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "84s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
		fi
		rm if_vol_${lp_count}
		python ${dynamic_script_path}/11_merge_profiles.py $SERVICE $i 'enforce'
		((lp_count++))
        done
#######################
	echo $x | source ${dynamic_script_path}/12_complain_enforce_audit.sh
	end_of_logs="1"
	for SERVICE in "${service_list[@]}"; do
		next_step=$(head -n 1 next_step_${SERVICE})
	        #echo "Next step for ${SERVICE} is $next_step"
	        if [[ "$next_step" == "0" ]]
	        then
		        end_of_logs="0"
		fi
	done
#######################
	((i++))
#######################
	if [[ "$end_of_logs" == "1" ]] #Then none of the services has 0 value so audit time
	then
	        break
	fi
done
######################

#version_{i} is the last profile
#Delete audit flag now
for SERVICE in "${service_list[@]}"; do
	python ${dynamic_script_path}/13_delete_audit_flag.py $SERVICE $i
	rm next_step_${SERVICE}
	cp ${app_run_path}/parser_output/profiles/${SERVICE}/output_${SERVICE}_profile ${app_run_path}/parser_output/${SERVICE}_profile
done
