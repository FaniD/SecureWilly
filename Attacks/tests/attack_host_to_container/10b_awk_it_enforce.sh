#!/bin/bash

#read version
mode="enforce"
run_path="."

mkdir ${run_path}/awk_out

	#~~~Capabilities~~~
	#dmesg logs
	#Find lines that include keyword "capability"
	awk '/capability/ {for(i=1;i<=NF;i++) {if($i ~ /capname/) print $i}}' ${run_path}/what_nsenter_needs_for_${mode} > tmp_file
	#Strip lines with capability to keep just the capname of each
	awk 'BEGIN {FS="=";} {gsub(/"/,"",$2); print $2;}' tmp_file > ${run_path}/awk_out/caps

	#Remove duplicates
	awk '!seen[$0]++' ${run_path}/awk_out/caps > ${run_path}/awk_out/${mode}_logs_caps


	#~~~Signal~~~

	#dmesg logs
        #Find lines that include keyword "signal"
	awk '/signal/ {for(i=1;i<=NF;i++) {{if($i ~ /requested_mask/) printf "%s ", $i} {if($i ~ /signal=/) printf "%s", $i} {if($i ~ /peer/) print "", $i}}}' ${run_path}/what_nsenter_needs_for_${mode} > tmp_file
	#To signal = den exei ""
	#Strip lines with requested_mask, signal and peer to keep just the tag of each
	awk 'BEGIN {FS="=| ";} {gsub(/"/,"",$2); gsub(/"/,"",$6); print $2 ',' $4 ',' $6;}' tmp_file > ${run_path}/awk_out/sgn
	
	#Remove duplicates
	awk '!seen[$0]++' ${run_path}/awk_out/sgn > ${run_path}/awk_out/${mode}_logs_sgn


	#~~~Network~~~
	
	#All net permissions
	for NET in create accept bind connect listen read write sendmsg recvmsg getsockname getpeername getsockopt setsockopt fcntl ioctl shutdown getpeersec; do

		#dmesg logs
		#Find lines that include keyword "create" for network - keep family and sock_type
		#Omit protocol, apparmor network rule needs at least 2 parameters
		awk -v net="$NET" '/net/ {for(i=1;i<=NF;i++) {{if($i ~ /family/) printf "%s", $i} {if($i ~ /sock_type/) print "", $i}}}' ${run_path}/what_nsenter_needs_for_${mode} > tmp_file
		#Strip lines with family and sock_type to keep just the tag of each
		awk 'BEGIN {FS="=| ";} {gsub(/"/,"",$2); gsub(/"/,"",$4); print $2 ',' $4;}' tmp_file > ${run_path}/awk_out/net
	done

        #Remove duplicates
	awk '!seen[$0]++' ${run_path}/awk_out/net > ${run_path}/awk_out/${mode}_logs_net


	#~~~File access rules~~~

	for OPERATION in create open delete rename read getattr getxattr write append trunc setattr setxattr chmod chown chgrp link snapshot lock mmap mprot exec change_profile onexec exectime; do
		#mmap_r mmap_w mmap_x mprot_wx mprot_xw 

		#dmesg logs
		#Find lines that include keyword "operation" from the operations loop - keep name and requested_mask
		awk -v operation="$OPERATION" '/operation/ {for(i=1;i<=NF;i++) {{if($i ~ /^name=/) printf "%s", $i} {if($i ~ /requested_mask/) print "", $i}}}' ${run_path}/what_nsenter_needs_for_${mode} > tmp_file
		#Strip lines with name and requested_mask to keep just the tag of each
		awk 'BEGIN {FS="=| ";} {gsub(/"/,"",$2); gsub(/"/,"",$4); print $2 ',' $4;}' tmp_file > ${run_path}/awk_out/file
	done

	#Remove duplicates
	awk '!seen[$0]++' ${run_path}/awk_out/file > ${run_path}/awk_out/${mode}_logs_file

	echo '#Capability\n' > ${run_path}/awk_out/${mode}
	cat ${run_path}/awk_out/${mode}_logs_caps >> ${run_path}/awk_out/${mode}
	echo '#Network\n' >> ${run_path}/awk_out/${mode}
	cat ${run_path}/awk_out/${mode}_logs_net >> ${run_path}/awk_out/${mode}
	echo '#File' >> ${run_path}/awk_out/${mode}
	cat ${run_path}/awk_out/${mode}_logs_file >> ${run_path}/awk_out/${mode}
	echo '#Signal' >> ${run_path}/awk_out/${mode}
	cat ${run_path}/awk_out/${mode}_logs_sgn >> ${run_path}/awk_out/${mode}

rm ${run_path}/awk_out/caps*
rm ${run_path}/awk_out/net*
rm ${run_path}/awk_out/file*
rm ${run_path}/awk_out/sgn*
rm tmp_file
