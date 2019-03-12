#!/bin/bash

service_list=(cloudsuitemedia-streamingdataset cloudsuitemedia-streamingserver cloudsuitemedia-streamingclient) 
app_path="../.."
parser_output_path="${app_path}/parser_output"
mkdir ${parser_output_path}/plots

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

./complain_enforce_audit.sh

#Do this manually depending on services
python plot_rules_total.py ${parser_output_path}/rules_${service_list[0]} ${parser_output_path}/rules_${service_list[1]} ${parser_output_path}/rules_${service_list[2]} $num_runs

mv ${parser_output_path}/*.png ${parser_output_path}/plots/

rm changes
rm run*

for SERVICE in "${service_list[@]}"; do
	rm ${parser_output_path}/rules_${SERVICE}
done
