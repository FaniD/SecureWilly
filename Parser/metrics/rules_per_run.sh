#!/bin/bash

profile_path="./client"
#profile_path="../parser_output/profiles/client"

ls ${profile_path} -1 | wc -l > num_of_runs

run=1
previous=0
while [ "$run" -le "echo $num_of_runs" ]; do
	wc -l ${profile_path}/version_${run} > ver
	echo "$((${ver} - 4 - ${previous}))" > previous
#	v = $ver - 4 - $previous
#	previous = $v
	echo "hey"
	echo $previous >> increasing_rules
	run=$(($run + 1))
done
echo $increasing_rules
