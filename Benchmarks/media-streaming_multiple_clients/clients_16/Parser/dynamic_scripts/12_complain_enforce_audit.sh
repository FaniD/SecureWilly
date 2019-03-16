#!/bin/bash

read round
#This script determines if dynamic parser is ready to move on to the next mode either enforce or complain
service_list=(cloudsuitemedia-streamingserver cloudsuitemedia-streamingclient1 cloudsuitemedia-streamingclient2 cloudsuitemedia-streamingclient3 cloudsuitemedia-streamingclient4 cloudsuitemedia-streamingclient5 cloudsuitemedia-streamingclient6 cloudsuitemedia-streamingclient7 cloudsuitemedia-streamingclient8 cloudsuitemedia-streamingclient9 cloudsuitemedia-streamingclient10 cloudsuitemedia-streamingclient11 cloudsuitemedia-streamingclient12 cloudsuitemedia-streamingclient13 cloudsuitemedia-streamingclient14 cloudsuitemedia-streamingclient15 cloudsuitemedia-streamingclient16 cloudsuitemedia-streamingdataset)
for service in "${service_list[@]}"; do
	#Compare 2 profiles by number of lines
	#Beware: There are no empty lines, comments are added next to rules, no duplicate rules, include and profile names are added as the same lines to each profile. So profiles are either augmentations of previous profiles or the same.
	wc -l ../parser_output/profiles/${service}/version_${round} | awk '{print $1}' > f1
	echo "$((${round} - 1))" > fr
	round_previous=$(head -n 1 fr)
	wc -l ../parser_output/profiles/${service}/version_${round_previous} | awk '{print $1}' > f2

	wc_f1=$(head -n 1 f1)
	wc_f2=$(head -n 1 f2)

	#If profiles are the same then go on to next step.
	if [ $wc_f1 == $wc_f2 ]
	then 
		echo "1" > next_step_${service} #More code here when I decide how to include the script in the project...
	else
		echo "0" > next_step_${service}
	fi
done

rm f1
rm f2
rm fr
