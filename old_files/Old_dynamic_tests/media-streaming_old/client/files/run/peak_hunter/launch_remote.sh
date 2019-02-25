#!/bin/bash

videoServerIp="$1"
hostFileName="$2"
remoteOutputPath="$3"
numClientsPerHost="$4"
numSessions="$5"
rate="$6"

if [ $# -ne 6 ]; then
  echo "Usage: launch_hunt_bin.sh <video_server_ip> <host_list_file> <remote_output_path> <num_clients_per_host> <num_sessions> <rate>"
  exit 
fi


# TODO: this needs to be fixed - need static correspondence between log, ratio, and ip
logs=$(echo /videos/logs/cl* | sed -e 's/ /,/g')

while read hostLine
do
	sIFS=$IFS; IFS=' :'; declare -a d=($hostLine); IFS=$sIFS
	host=${d[0]}
	#ips=$(echo ${d[@]:1:100} | sed -e 's/-[^ ]*//g' -e 's/ /,/g')
	#ssh $host "sudo mkdir -m 0777 -p $remoteOutputPath/results"
	echo "Launching $numClientsPerHost clients on $host";
	for i in $(seq 1 $numClientsPerHost)
	do
	cmd="httperf --hog --server $videoServerIp --videosesslog=[$logs],[0.1,0.3,0.4,0.2],[localhost,localhost,localhost,localhost] --epoll --recv-buffer=524288 --port 80 --output-log=/output/result$i.log --num-sessions=$numSessions --rate=$rate 2>>/output/bt$i.trace" # > output-stdout/stdout$i"
	echo "Running command $cmd"
	eval $cmd &
	done 
	wait
done < "$hostFileName"
