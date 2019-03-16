#!/bin/bash

read round
#This script determines if dynamic parser is ready to move on to the next mode either enforce or complain
service_list=(cloudsuitemedia-streamingserver cloudsuitemedia-streamingclient1 cloudsuitemedia-streamingclient2 cloudsuitemedia-streamingclient3 cloudsuitemedia-streamingclient4 cloudsuitemedia-streamingclient5 cloudsuitemedia-streamingclient6 cloudsuitemedia-streamingclient7 cloudsuitemedia-streamingclient8 cloudsuitemedia-streamingclient9 cloudsuitemedia-streamingclient10 cloudsuitemedia-streamingclient11 cloudsuitemedia-streamingclient12 cloudsuitemedia-streamingclient13 cloudsuitemedia-streamingclient14 cloudsuitemedia-streamingclient15 cloudsuitemedia-streamingclient16 cloudsuitemedia-streamingclient17 cloudsuitemedia-streamingclient18 cloudsuitemedia-streamingclient19 cloudsuitemedia-streamingclient20 cloudsuitemedia-streamingclient21 cloudsuitemedia-streamingclient22 cloudsuitemedia-streamingclient23 cloudsuitemedia-streamingclient24 cloudsuitemedia-streamingclient25 cloudsuitemedia-streamingclient26 cloudsuitemedia-streamingclient27 cloudsuitemedia-streamingclient28 cloudsuitemedia-streamingclient29 cloudsuitemedia-streamingclient30 cloudsuitemedia-streamingclient31 cloudsuitemedia-streamingclient32 cloudsuitemedia-streamingclient33 cloudsuitemedia-streamingclient34 cloudsuitemedia-streamingclient35 cloudsuitemedia-streamingclient36 cloudsuitemedia-streamingclient37 cloudsuitemedia-streamingclient38 cloudsuitemedia-streamingclient39 cloudsuitemedia-streamingclient40 cloudsuitemedia-streamingclient41 cloudsuitemedia-streamingclient42 cloudsuitemedia-streamingclient43 cloudsuitemedia-streamingclient44 cloudsuitemedia-streamingclient45 cloudsuitemedia-streamingclient46 cloudsuitemedia-streamingclient47 cloudsuitemedia-streamingclient48 cloudsuitemedia-streamingclient49 cloudsuitemedia-streamingclient50 cloudsuitemedia-streamingclient51 cloudsuitemedia-streamingclient52 cloudsuitemedia-streamingclient53 cloudsuitemedia-streamingclient54 cloudsuitemedia-streamingclient55 cloudsuitemedia-streamingclient56 cloudsuitemedia-streamingclient57 cloudsuitemedia-streamingclient58 cloudsuitemedia-streamingclient59 cloudsuitemedia-streamingclient60 cloudsuitemedia-streamingclient61 cloudsuitemedia-streamingclient62 cloudsuitemedia-streamingclient63 cloudsuitemedia-streamingclient64 cloudsuitemedia-streamingdataset)
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
