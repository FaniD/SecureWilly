#!/bin/bash

app_path="../.."
parser_output_path="${app_path}/parser_output"

logs_path="${parser_output_path}/Logs"

ls ${logs_path} -1 | wc -l > num_of_runs
num_runs=$(head -n 1 num_of_runs)
#${logs_path}/*; do
for run in range(1,num_of_runs) do
	ls ${logs_path}/RUN${run}/awk_out/ | grep complain | wc -l > c_runs
	complain_runs=$(head -n 1 c_runs)
	if [[ "$complain_runs" > 0 ]]; then
		echo $complain_runs >> last_complain
	fi

        ls ${logs_path}/RUN${run}/awk_out/ | grep complain | wc -l > e_runs
	enforce_runs=$(head -n 1 e_runs)
	if [[ "$enforce_runs" > 0 ]]; then 
		echo $enforce_runs >> last_enforce
	fi

done
