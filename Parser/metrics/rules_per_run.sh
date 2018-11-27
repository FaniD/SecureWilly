#!/bin/bash

service_list=(dataset server client) 

for SERVICE in "${service_list[@]}"; do
	profile_path="./client"
	#profile_path="../../parser_output/profiles/${SERVICE}"

	ls ${profile_path} -1 | wc -l > num_of_runs

	previous=0
	for run in ${profile_path}/*; do
		wc -l $run | awk '{print $1}' > f
		f1=$(head -n 1 f)
		echo "$((${f1} - 4 - $previous))" > fr
		previous=$(head -n 1 fr)
		echo $previous >> ../../parser_output/increasing_rules_${SERVICE}
	done
	rm f
	rm fr
	rm num_of_runs
done
