#!/bin/bash

for SERVICE in server client dataset; do
#for N in 1 ... ${SERVICES} ; do

	#Capabilities
	#kern logs
	#Find lines that include keyword "capability"
	awk '/capability/ {print $16;}' ../media-streaming/audit_messages/complain_messages/kernlogs_${SERVICE} > tmp_file
	#Strip lines with capability to keep just the capname of each
	awk 'BEGIN {FS="=";} {gsub(/"/,"",$2); print $2;}' tmp_file > awk_out/caps_${SERVICE}
	echo '' > tmp_file

	#dmesg logs
	#Find lines that include keyword "capability"
	awk '/capability/ {print $11;}' ../media-streaming/audit_messages/complain_messages/dmesg_${SERVICE} > tmp_file
	#Strip lines with capability to keep just the capname of each
	awk 'BEGIN {FS="=";} {gsub(/"/,"",$2); print $2;}' tmp_file >> awk_out/caps_${SERVICE}
	echo '' > tmp_file

	#Network
	#kern logs
	#Find lines that include keyword "create" for network - keep family and sock_type
	#Omit protocol, apparmor network rule needs at least 2 parameters
	awk '/create/ {print $15 ',' $16;}' ../media-streaming/audit_messages/complain_messages/kernlogs_${SERVICE} > tmp_file
	#Strip lines with family and sock_type to keep just the tag of each
	awk 'BEGIN {FS="=| ";} {gsub(/"/,"",$2); gsub(/"/,"",$4); print $2 ',' $4;}' tmp_file > awk_out/net_${SERVICE}
	echo '' > tmp_file

	#dmesg logs
	#Find lines that include keyword "create" for network - keep family and sock_type
	#Omit protocol, apparmor network rule needs at least 2 parameters
	awk '/create/ {print $10 ',' $11;}' ../media-streaming/audit_messages/complain_messages/dmesg_${SERVICE} > tmp_file
	#Strip lines with family and sock_type to keep just the tag of each
	awk 'BEGIN {FS="=| ";} {gsub(/"/,"",$2); gsub(/"/,"",$4); print $2 ',' $4;}' tmp_file >> awk_out/net_${SERVICE}
	echo '' > tmp_file

	rm tmp_file
done
