#!/bin/bash

profile_path="../profiles/client"

ls ${profile_path} -1 | wc -l > num_of_runs

previous=0
for (( run=1; run<num_of_runs; run++ )) do
	wc -l ${profile_path}/version_${run} > ver
	version_${run} = $ver - 4 - $previous
	previous = ${version}_${run}
	cat previous >> increasing_rules
done
