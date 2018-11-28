#!/bin/bash

service_list=(dataset server client) 

for SERVICE in "${service_list[@]}"; do
	#profile_path="./${SERVICE}"
	profile_path="../../parser_output/profiles/${SERVICE}"

	#Count how many runs there have been
	ls ${profile_path} -1 | wc -l > num_of_runs

	previous=0
	for run in ${profile_path}/*; do
		wc -l $run | awk '{print $1}' > f
		f1=$(head -n 1 f)
		echo "$((${f1} - 4))" > fr
		previous=$(head -n 1 fr)
		echo $previous >> ../../parser_output/rules_${SERVICE}
	done
	rm f
	rm fr
done

#Do this manually depending on services
python plot.py ../../parser_output/rules_dataset ../../parser_output/rules_client ../../parser_output/rules_server num_of_runs
