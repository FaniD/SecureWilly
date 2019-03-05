#!/bin/bash

app_path="../.."
parser_output_path="${app_path}/parser_output"

logs_path="${parser_output_path}/Logs"

ls ${logs_path} -1 | wc -l > num_of_runs
num_runs=$(head -n 1 num_of_runs)
rm num_of_runs

run=2
while [[  "$run" -le "$num_runs" ]]; do
	let prev=run-1
	ls ${logs_path}/RUN${prev}/awk_out/ | grep complain | wc -l > run1
	ls ${logs_path}/RUN${run}/awk_out/ | grep enforce | wc -l > run2
        ls ${logs_path}/RUN${prev}/awk_out/ | grep enforce | wc -l > run3
	ls ${logs_path}/RUN${run}/awk_out/ | grep complain | wc -l > run4

	run_1=$(head -n 1 run1)
	run_2=$(head -n 1 run2)
	run_3=$(head -n 1 run3)
	run_4=$(head -n 1 run4)

	if [[ ( "$run_1" > "0"  &&  "$run_2" > "0" ) || ( "$run_3" > "0" && "$run_4" > "0" ) ]]; then
		echo $run >> changes
	fi
	let run=run+1
done
