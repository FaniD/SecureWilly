#!/bin/bash

profile_path = "client"
#profile_path="../parser_output/profiles/client"

ls ${profile_path} -1 | wc -l > num_of_runs

previous=0
for (( run=1; run<num_of_runs; run++ )) do
	wc -l ${profile_path}/version_${run} > ver
	echo "$((${ver} - 4 - ${previous}))" > previous
#	v = $ver - 4 - $previous
#	previous = $v
	cat previous >> increasing_rules
done
