#!/bin/bash

for SERVICE in server client dataset; do
#for N in 1 ... ${SERVICES} ; do

	#Capabilities
	#kern logs
	awk '/capability/ {print $16;}' ../media-streaming/audit_messages/complain_messages/kernlogs_${SERVICE} > tmp_file
	awk 'BEGIN {FS="=";} {gsub(/"/,"",$2); print $2;}' tmp_file > awk_out/caps1_${SERVICE}
	rm tmp_file

	#dmesg logs
	awk '/capability/ {print $11;}' ../media-streaming/audit_messages/complain_messages/dmesg_${SERVICE} > tmp_file
	awk 'BEGIN {FS="=";} {gsub(/"/,"",$2); print $2;}' tmp_file > awk_out/caps2_${SERVICE}
	rm tmp_file

	#Network
	#kern logs
	awk '/create/ {print $15 ',' $16;}' ../media-streaming/audit_messages/complain_messages/kernlogs_${SERVICE} > tmp_file
	awk 'BEGIN {FS="=| ";} {gsub(/"/,"",$2); gsub(/"/,"",$4); print $2 ',' $4;}' tmp_file > awk_out/net1_${SERVICE}
	rm tmp_file

done
