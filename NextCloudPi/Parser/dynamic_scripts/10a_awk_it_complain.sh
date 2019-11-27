#!/bin/bash

read version
mode="complain"
run_path="../parser_output/Logs/RUN${version}"
system_command="journalctl" #dmesg
logs="audit" #kernlogs
mkdir ${run_path}/awk_out

#For each service, separate logs into different categories
service_list=(nextcloudpi)
for SERVICE in "${service_list[@]}"; do

	#~~~Capabilities~~~

	# logs
	# Find lines that include keyword "capability"
	awk '/capability/ {for(i=1;i<=NF;i++) {if($i ~ /capname/) print $i}}' ${run_path}/${logs}_${SERVICE} > tmp_file
	# Strip lines with capability to keep just the capname of each
	awk 'BEGIN {FS="=";} {gsub(/"/,"",$2); print $2;}' tmp_file > ${run_path}/awk_out/caps_${SERVICE}

	# System logs
	# Find lines that include keyword "capability"
	awk '/capability/ {for(i=1;i<=NF;i++) {if($i ~ /capname/) print $i}}' ${run_path}/${system_command}_${SERVICE} > tmp_file
	#Strip lines with capability to keep just the capname of each
	awk 'BEGIN {FS="=";} {gsub(/"/,"",$2); print $2;}' tmp_file >> ${run_path}/awk_out/caps_${SERVICE}

	# Remove duplicates
	awk '!seen[$0]++' ${run_path}/awk_out/caps_${SERVICE} > ${run_path}/awk_out/${mode}_logs_caps_${SERVICE}


	#~~~Signal~~~

	# logs
	# Find lines that include keyword "signal"
	awk '/signal/ {for(i=1;i<=NF;i++) {{if($i ~ /requested_mask/) printf "%s ", $i} {if($i ~ /signal=/) printf "%s", $i} {if($i ~ /peer/) print "", $i}}}' ${run_path}/${logs}_${SERVICE} > tmp_file
	# To signal = den exei ""
	# Strip lines with requested_mask, signal and peer to keep just the tag of each
        awk 'BEGIN {FS="=| ";} {gsub(/"/,"",$2); gsub(/"/,"",$6); print $2 ',' $4 ',' $6;}' tmp_file >> ${run_path}/awk_out/sgn_${SERVICE}

	# System logs
        # Find lines that include keyword "signal"
	awk '/signal/ {for(i=1;i<=NF;i++) {{if($i ~ /requested_mask/) printf "%s ", $i} {if($i ~ /signal=/) printf "%s", $i} {if($i ~ /peer/) print "", $i}}}' ${run_path}/${system_command}_${SERVICE} > tmp_file
	# To signal = den exei ""
	# Strip lines with requested_mask, signal and peer to keep just the tag of each
	awk 'BEGIN {FS="=| ";} {gsub(/"/,"",$2); gsub(/"/,"",$6); print $2 ',' $4 ',' $6;}' tmp_file >> ${run_path}/awk_out/sgn_${SERVICE}
	
	# Remove duplicates
	awk '!seen[$0]++' ${run_path}/awk_out/sgn_${SERVICE} > ${run_path}/awk_out/${mode}_logs_sgn_${SERVICE}


	#~~~Network~~~
	
	# All net permissions
	# for NET in create accept bind connect listen read write sendmsg recvmsg getsockname getpeername getsockopt setsockopt fcntl ioctl shutdown getpeersec; do

	# TODO: Needs fixing, because NET keywords are the same with operations in file access!!! For the moment, the search is only done by keyword family which is only encountered in network logs

	# kern logs
	# Find lines that include keyword "create" for network - keep family and sock_type
	# Omit protocol, apparmor network rule needs at least 2 parameters
	
	awk '/family/ {for(i=1;i<=NF;i++) {{if($i ~ /family/) printf "%s", $i} {if($i ~ /sock_type/) print "", $i}}}' ${run_path}/${logs}_${SERVICE} > tmp_file
	#awk -v net="$NET" '/net/ {for(i=1;i<=NF;i++) {{if($i ~ /family/) printf "%s", $i} {if($i ~ /sock_type/) print "", $i}}}' ${run_path}/kernlogs_${SERVICE} > tmp_file
	# Strip lines with family and sock_type to keep just the tag of each
	awk 'BEGIN {FS="=| ";} {gsub(/"/,"",$2); gsub(/"/,"",$4); print $2 ',' $4;}' tmp_file >> ${run_path}/awk_out/net_${SERVICE}

	# System logs
	# Find lines that include keyword "create" for network - keep family and sock_type
	# Omit protocol, apparmor network rule needs at least 2 parameters
	awk '/family/ {for(i=1;i<=NF;i++) {{if($i ~ /family/) printf "%s", $i} {if($i ~ /sock_type/) print "", $i}}}' ${run_path}/${system_command}_${SERVICE} > tmp_file
	#awk -v net="$NET" '/net/ {for(i=1;i<=NF;i++) {{if($i ~ /family/) printf "%s", $i} {if($i ~ /sock_type/) print "", $i}}}' ${run_path}/dmesg_${SERVICE} > tmp_file
	# Strip lines with family and sock_type to keep just the tag of each
	awk 'BEGIN {FS="=| ";} {gsub(/"/,"",$2); gsub(/"/,"",$4); print $2 ',' $4;}' tmp_file >> ${run_path}/awk_out/net_${SERVICE}
	#done

        # Remove duplicates
	awk '!seen[$0]++' ${run_path}/awk_out/net_${SERVICE} > ${run_path}/awk_out/${mode}_logs_net_${SERVICE}


	#~~~File access rules~~~

	for OPERATION in create open delete rename read getattr getxattr write append trunc setattr setxattr chmod chown chgrp link snapshot lock mmap mprot exec change_profile onexec exectime; do
		#mmap_r mmap_w mmap_x mprot_wx mprot_xw 

		# logs
		# Find lines that include keyword "operation" from the operations loop - keep name and requested_mask
		# Beware! getsockname & getpeername are net operations but they include keyword name so we add /name=/ to keep them out of my file rules search
		awk -v operation="$OPERATION" '/operation/ {for(i=1;i<=NF;i++) {{if($i ~ /^name=/) printf "%s", $i} {if($i ~ /requested_mask/) print "", $i}}}' ${run_path}/${logs}_${SERVICE} > tmp_file
		# Strip lines with name and requested_mask to keep just the tag of each
		awk 'BEGIN {FS="=| ";} {gsub(/"/,"",$2); gsub(/"/,"",$4); print $2 ',' $4;}' tmp_file >> ${run_path}/awk_out/file_${SERVICE}

		# System logs
		# Find lines that include keyword "operation" from the operations loop - keep name and requested_mask
		awk -v operation="$OPERATION" '/operation/ {for(i=1;i<=NF;i++) {{if($i ~ /^name=/) printf "%s", $i} {if($i ~ /requested_mask/) print "", $i}}}' ${run_path}/${system_command}_${SERVICE} > tmp_file
		# Strip lines with name and requested_mask to keep just the tag of each
		awk 'BEGIN {FS="=| ";} {gsub(/"/,"",$2); gsub(/"/,"",$4); print $2 ',' $4;}' tmp_file >> ${run_path}/awk_out/file_${SERVICE}
	done

	# Remove duplicates
	awk '!seen[$0]++' ${run_path}/awk_out/file_${SERVICE} > ${run_path}/awk_out/${mode}_logs_file_${SERVICE}

	echo '#Capability\n' > ${run_path}/awk_out/${mode}_${SERVICE}
	cat ${run_path}/awk_out/${mode}_logs_caps_${SERVICE} >> ${run_path}/awk_out/${mode}_${SERVICE}
	echo '#Network\n' >> ${run_path}/awk_out/${mode}_${SERVICE}
	cat ${run_path}/awk_out/${mode}_logs_net_${SERVICE} >> ${run_path}/awk_out/${mode}_${SERVICE}
	echo '#File' >> ${run_path}/awk_out/${mode}_${SERVICE}
	cat ${run_path}/awk_out/${mode}_logs_file_${SERVICE} >> ${run_path}/awk_out/${mode}_${SERVICE}
	echo '#Signal' >> ${run_path}/awk_out/${mode}_${SERVICE}
	cat ${run_path}/awk_out/${mode}_logs_sgn_${SERVICE} >> ${run_path}/awk_out/${mode}_${SERVICE}

done

rm ${run_path}/awk_out/caps*
rm ${run_path}/awk_out/net*
rm ${run_path}/awk_out/file*
rm ${run_path}/awk_out/sgn*
rm tmp_file
