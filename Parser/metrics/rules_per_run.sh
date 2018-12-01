#!/bin/bash

service_list=(dataset server client) 
app_path="../.."
parser_output_path="${app_path}/parser_output"

for SERVICE in "${service_list[@]}"; do
	profile_path="${parser_output_path}/profiles/${SERVICE}"
	
	#Count how many runs there have been
	ls ${profile_path} -1 | wc -l > num_of_runs

	previous=0
	#Look inside directory and run for every version file
	for run in ${profile_path}/*; do
		#count lines
		wc -l $run | awk '{print $1}' > f
		f1=$(head -n 1 f)
		#Decrease by 4 which are the intro and closure of the profile, that shouldn't be included in rules
		echo "$((${f1} - 4))" > fr
		previous=$(head -n 1 fr)
		echo $previous >> ${parser_output_path}/rules_${SERVICE}
	done
	rm f
	rm fr
done
num_runs=$(head -n 1 num_of_runs)
rm num_of_runs

#Do this manually depending on services
python plot_rules_total.py ${parser_output_path}/rules_dataset ${parser_output_path}/rules_client ${parser_output_path}/rules_server $num_runs

for SERVICE in "${service_list[@]}"; do
	rm ${parser_output_path}/rules_${SERVICE}
done
