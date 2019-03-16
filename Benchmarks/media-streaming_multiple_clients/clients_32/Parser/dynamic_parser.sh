#!/bin/bash

#Change this with the services I have each time
#Also do that in 2_cp, 3, 4a, 4b, 9, 10a, 10b, 12, metrics 
service_list=(cloudsuitemedia-streamingserver cloudsuitemedia-streamingclient1 cloudsuitemedia-streamingclient2 cloudsuitemedia-streamingclient3 cloudsuitemedia-streamingclient4 cloudsuitemedia-streamingdataset)

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

#./${dynamic_script_path}/0b_pull_images.sh
rm time_of_runs
touch time_of_runs

#For each RUN follow the steps
i=1
enforce="0"
abort_net=true
while [[ "$enforce" == "0" ]]; do

	#Complain mode
	while true; do
		echo $i | source ${dynamic_script_path}/2_cp_to_apparmor.sh
		./${dynamic_script_path}/3_load_profiles.sh 
		./${dynamic_script_path}/4a_complain_mode.sh
		./${dynamic_script_path}/5_clear_logs.sh 
		./${dynamic_script_path}/6_net.sh
		#./${dynamic_script_path}/7_run.sh
		echo "RUN ${i}" >> time_of_runs
		time ( ./${dynamic_script_path}/7_run.sh ) 2> time_out
		cat time_out >> time_of_runs
		rm time_out
		echo $i | source ${dynamic_script_path}/8_logging_files.sh
		./${dynamic_script_path}/9a_clear_containers_net.sh
		./${dynamic_script_path}/9b_clear_compose.sh
		./${dynamic_script_path}/9c_clear_volumes.sh
		echo $i | source ${dynamic_script_path}/10a_awk_it_complain.sh
		x=${x:-$i}
		((x++))
		lp_count=0
		for SERVICE in "${service_list[@]}"; do
			#Abort net of static analysis if it exists
			#Because in logs, we get more specific network rules
			if $abort_net ; then
				if_net=$(wc -l ${app_run_path}/parser_output/Logs/RUN1/awk_out/complain_logs_net_${SERVICE} | cut -d' ' -f1)
				if [[ "$if_net" != "0" ]]; then
					#If there are already rules by the testplan then abort network static rule, as it will get more specific on ports eitheir inet or inet6 etc
					python ${dynamic_script_path}/1_abort_network_rule.py $SERVICE
				fi
			fi
		
			#Named volumes
			vol_str=$(cut -d'%' -f1 if_vol_${SERVICE})
			num_vols=$(cut -d'%' -f2 if_vol_${SERVICE})
			if [[ "$num_vols" == "0" ]]; then
				python ${dynamic_script_path}/11_merge_profiles.py $SERVICE $i 'complain'
			else
				sed -i "83s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
				sed -i "83s|if .*|if ${vol_str}|" ${dynamic_script_path}/11_merge_profiles.py
				sed -i "84s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
				python ${dynamic_script_path}/11_merge_profiles.py $SERVICE $i 'complain'
				sed -i "83s| if|#if|" ${dynamic_script_path}/11_merge_profiles.py
				sed -i "84s| c|#c|" ${dynamic_script_path}/11_merge_profiles.py
			fi
			((lp_count++))
		done
		abort_net=false
		echo $x | source ${dynamic_script_path}/12_complain_enforce_audit.sh
		enforce_time='1'
		for SERVICE in "${service_list[@]}"; do
			next_step=$(head -n 1 next_step_${SERVICE})
			if [[ "$next_step" == "0" ]]
			then
				enforce_time="0"
			fi
		done
		cp -r /output ${app_run_path}/parser_output/output_run_${i}
		((i++))
		if [[ "$enforce_time" == "1" ]] #Then none of the services has 0 value so enforce time
		then
			break
		fi	
	done

	enforce="1"

	echo $i | source ${dynamic_script_path}/2_cp_to_apparmor.sh
	./${dynamic_script_path}/3_load_profiles.sh
	./${dynamic_script_path}/4b_enforce_mode.sh
	./${dynamic_script_path}/5_clear_logs.sh
	./${dynamic_script_path}/6_net.sh
	#./${dynamic_script_path}/7_run.sh
	echo "RUN ${i}" >> time_of_runs
	time ( ./${dynamic_script_path}/7_run.sh ) 2> time_out
	cat time_out >> time_of_runs
	rm time_out
	echo $i | source ${dynamic_script_path}/8_logging_files.sh
	./${dynamic_script_path}/9a_clear_containers_net.sh
	./${dynamic_script_path}/9b_clear_compose.sh
	./${dynamic_script_path}/9c_clear_volumes.sh
	echo $i | source ${dynamic_script_path}/10b_awk_it_enforce.sh
	x=${x:-$i}
	((x++))
	lp_count=0
	for SERVICE in "${service_list[@]}"; do 
		vol_str=$(cut -d'%' -f1 if_vol_${SERVICE})
		num_vols=$(cut -d'%' -f2 if_vol_${SERVICE})
		if [[ "$num_vols" == "0" ]]; then
			python ${dynamic_script_path}/11_merge_profiles.py $SERVICE $i 'enforce'
		else
			sed -i "83s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "83s|if .*|if ${vol_str}|" ${dynamic_script_path}/11_merge_profiles.py
			sed -i "84s/#/ /" ${dynamic_script_path}/11_merge_profiles.py
			python ${dynamic_script_path}/11_merge_profiles.py $SERVICE $i 'enforce'
			sed -i "83s| if|#if|" ${dynamic_script_path}/11_merge_profiles.py
		        sed -i "84s| c|#c|" ${dynamic_script_path}/11_merge_profiles.py
		fi
		((lp_count++))
	done
	echo $x | source ${dynamic_script_path}/12_complain_enforce_audit.sh
	for SERVICE in "${service_list[@]}"; do
		next_step=$(head -n 1 next_step_${SERVICE})
		if [[ "$next_step" == "0" ]]
		then
			enforce="0"
		fi
	done
	cp -r /output ${app_run_path}/parser_output/output_run_${i}
	((i++))
done

#version_{i} is the last profile
#Delete audit flag now
for SERVICE in "${service_list[@]}"; do
	cp ${app_run_path}/parser_output/profiles/${SERVICE}/version_${i} ${app_run_path}/parser_output/profiles/${SERVICE}/output_${SERVICE}_profile
	rm next_step_${SERVICE}
	cp ${app_run_path}/parser_output/profiles/${SERVICE}/output_${SERVICE}_profile ${app_run_path}/parser_output/${SERVICE}_profile
done
