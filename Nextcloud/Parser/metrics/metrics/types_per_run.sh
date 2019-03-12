#!/bin/bash

service_list=(cloudsuitemedia-streamingdataset cloudsuitemedia-streamingserver cloudsuitemedia-streamingclient) 
app_path="../.."
parser_output_path="${app_path}/parser_output"
mkdir ${parser_output_path}/plots

./complain_enforce_audit.sh

for SERVICE in "${service_list[@]}"; do
	profile_path="${parser_output_path}/profiles/${SERVICE}"

	#Count how many runs there have been (=how many profiles there are in profile dir)
	ls ${profile_path} -1 | wc -l > num_of_runs
	num_runs=$(head -n 1 num_of_runs)

	#Search per type
	for run in ${profile_path}/*; do
		#count total lines of each profile
		wc -l $run | awk '{print $1}' > f
		total_r=$(head -n 1 f)
		#Decrease by 4 which are the intro and closure of the profile, that shouldn't be included in rules
		echo "$((${total_r} - 4))" > fr
		total_rules=$(head -n 1 fr)
		
		#We make sure that the keywords used are not names of files and are used in specific syntax either on their own or with allow or deny
		#Awk counter gives null when no string matches so we change it to 0 when needed
	
		#Capability rules
		awk '/\tcapability,|\tcapability | capability,| capability / {count++} END {print count}' ${run} > awk_counter
		cap=$(head -n 1 awk_counter)
		if [[ $cap == "" ]]; then
			cap=0
			echo "0" >> ${parser_output_path}/capability_${SERVICE}
		else	
			cat awk_counter >> ${parser_output_path}/capability_${SERVICE}
		fi
		
		#Network rules
		awk '/\tnetwork,|\tnetwork | network,| network / {count++} END {print count}' ${run} > awk_counter
		net=$(head -n 1 awk_counter)
		if [[ $net == "" ]]; then
			net=0
			echo "0" >> ${parser_output_path}/network_${SERVICE}
		else
			cat awk_counter	>> ${parser_output_path}/network_${SERVICE}
		fi

		#Signal rules
		awk '/\tsignal,|\tsignal | signal,| signal / {count++} END {print count}' ${run} > awk_counter
		sgn=$(head -n 1 awk_counter)
		if [[ $sgn == "" ]]; then
			sgn=0
			echo "0" >> ${parser_output_path}/signal_${SERVICE}
		else
			cat awk_counter >> ${parser_output_path}/signal_${SERVICE}
		fi

		#Mount rules
		awk '/\tmount,|\tmount | mount,| mount |\tumount,|\tumount | umount,| umount |\tremount,|\tremount | remount,| remount / {count++} END {print count}' ${run} > awk_counter #also, remount & umount counted
                mnt=$(head -n 1 awk_counter)
		if [[ $mnt == "" ]]; then
			mnt=0
			echo "0" >> ${parser_output_path}/mount_${SERVICE}
		else
			cat awk_counter >> ${parser_output_path}/mount_${SERVICE}
		fi

		#Rlimit rules
		awk '/\tset rlimit | set rlimit / {count++} END {print count}' ${run} > awk_counter
		rlim=$(head -n 1 awk_counter)
                if [[ $rlim == "" ]]; then
			rlim=0
			echo "0" >> ${parser_output_path}/rlimit_${SERVICE}
		else
			cat awk_counter >> ${parser_output_path}/rlimit_${SERVICE}
		fi
		
		#Everything else belongs to file rules
		echo "$((${total_rules} - ${cap} - ${net} - ${sgn} - ${mnt} - ${rlim}))" >> ${parser_output_path}/file_rules_${SERVICE}
	done

	#Plot per service
	python plot_type_rules.py ${parser_output_path}/capability_${SERVICE} ${parser_output_path}/network_${SERVICE} ${parser_output_path}/signal_${SERVICE} ${parser_output_path}/mount_${SERVICE} ${parser_output_path}/rlimit_${SERVICE} ${parser_output_path}/file_rules_${SERVICE} $num_runs ${SERVICE}

	rm ${parser_output_path}/capability_${SERVICE}
	rm ${parser_output_path}/network_${SERVICE}
	rm ${parser_output_path}/signal_${SERVICE}
	rm ${parser_output_path}/mount_${SERVICE}
	rm ${parser_output_path}/rlimit_${SERVICE}
	rm ${parser_output_path}/file_rules_${SERVICE}
done

mv ${parser_output_path}/*.png ${parser_output_path}/plots/

rm changes
rm run*
rm f
rm fr
rm num_of_runs
rm awk_counter
