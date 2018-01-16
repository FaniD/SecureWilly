#!/bin/bash

for SERVICE in server client dataset; do
#for N in 1 ... ${SERVICES} ; do

	#~~~Capabilities~~~

	#kern logs
	#Find lines that include keyword "capability"
	awk '/capability/ {for(i=1;i<=NF;i++) {if($i ~ /capname/) print $i}}' ../media-streaming/audit_messages/complain_messages/new/kernlogs_${SERVICE} > tmp_file
	#Strip lines with capability to keep just the capname of each
	awk 'BEGIN {FS="=";} {gsub(/"/,"",$2); print $2;}' tmp_file > awk_out/caps_${SERVICE}

	#dmesg logs
	#Find lines that include keyword "capability"
	awk '/capability/ {for(i=1;i<=NF;i++) {if($i ~ /capname/) print $i}}' ../media-streaming/audit_messages/complain_messages/new/dmesg_${SERVICE} > tmp_file
	#Strip lines with capability to keep just the capname of each
	awk 'BEGIN {FS="=";} {gsub(/"/,"",$2); print $2;}' tmp_file >> awk_out/caps_${SERVICE}

	#Remove duplicates
	awk '!seen[$0]++' awk_out/caps_${SERVICE} > awk_out/complainlogs_caps_${SERVICE}


	#~~~Network~~~
	
	#All net permissions
	for NET in create accept bind connect listen read write send receive getsockname getpeername getsockopt setsockopt fcntl ioctl shutdown getpeersec; do
		#kern logs
		#Find lines that include keyword "create" for network - keep family and sock_type
		#Omit protocol, apparmor network rule needs at least 2 parameters
		awk -v net="$NET" '/net/ {for(i=1;i<=NF;i++) {{if($i ~ /family/) printf "%s", $i} {if($i ~ /sock_type/) print "", $i}}}' ../media-streaming/audit_messages/complain_messages/new/kernlogs_${SERVICE} > tmp_file
		#Strip lines with family and sock_type to keep just the tag of each
		awk 'BEGIN {FS="=| ";} {gsub(/"/,"",$2); gsub(/"/,"",$4); print $2 ',' $4;}' tmp_file >> awk_out/net_${SERVICE}

		#dmesg logs
		#Find lines that include keyword "create" for network - keep family and sock_type
		#Omit protocol, apparmor network rule needs at least 2 parameters
		awk -v net="$NET" '/net/ {for(i=1;i<=NF;i++) {{if($i ~ /family/) printf "%s", $i} {if($i ~ /sock_type/) print "", $i}}}' ../media-streaming/audit_messages/complain_messages/new/dmesg_${SERVICE} > tmp_file
		#Strip lines with family and sock_type to keep just the tag of each
		awk 'BEGIN {FS="=| ";} {gsub(/"/,"",$2); gsub(/"/,"",$4); print $2 ',' $4;}' tmp_file >> awk_out/net_${SERVICE}
	done

        #Remove duplicates
	awk '!seen[$0]++' awk_out/net_${SERVICE} > awk_out/complainlogs_net_${SERVICE}


	#~~~File access rules~~~

	for OPERATION in create open delete rename read getattr getxattr write append trunc setattr setxattr chmod chown chgrp link snapshot lock mmap mprot exec change_profile onexec exectime; do
		#mmap_r mmap_w mmap_x mprot_wx mprot_xw 

		#kernlogs
		#Find lines that include keyword "operation" from the operations loop - keep name and requested_mask
		awk -v operation="$OPERATION" '/operation/ {for(i=1;i<=NF;i++) {{if($i ~ /name/) printf "%s", $i} {if($i ~ /requested_mask/) print "", $i}}}' ../media-streaming/audit_messages/complain_messages/new/kernlogs_${SERVICE} > tmp_file
		#Strip lines with name and requested_mask to keep just the tag of each
		awk 'BEGIN {FS="=| ";} {gsub(/"/,"",$2); gsub(/"/,"",$4); print $2 ',' $4;}' tmp_file >> awk_out/file_${SERVICE}

		#dmesg logs
		#Find lines that include keyword "operation" from the operations loop - keep name and requested_mask
		awk -v operation="$OPERATION" '/operation/ {for(i=1;i<=NF;i++) {{if($i ~ /name/) printf "%s", $i} {if($i ~ /requested_mask/) print "", $i}}}' ../media-streaming/audit_messages/complain_messages/new/dmesg_${SERVICE} > tmp_file
		#Strip lines with name and requested_mask to keep just the tag of each
		awk 'BEGIN {FS="=| ";} {gsub(/"/,"",$2); gsub(/"/,"",$4); print $2 ',' $4;}' tmp_file >> awk_out/file_${SERVICE}
	done

	#Remove duplicates
	awk '!seen[$0]++' awk_out/file_${SERVICE} > awk_out/complainlogs_file_${SERVICE}
done

rm awk_out/caps*
rm awk_out/net*
rm awk_out/file*
rm tmp_file
