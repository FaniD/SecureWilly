#!/bin/bash

#Change this with the services I have each time
#Also do that in 2_cp, 3, 4a, 4b, 9, 10a, 10b, 12, metrics 

app_run_path=".."
parser_path="${app_run_path}/Parser"
dynamic_script_path="${parser_path}/dynamic_scripts"

static=false
touch empty_file

echo "SecureWily"
echo "Copyright (c) 2019 Fani Dimou <fani.dimou92@gmail.com>"
echo ""

#Static Part requirements
#Dockerfile
echo "Is there a Dockerfile to provide?"
echo "If yes, give the full path to Dockerfile (<path_to_dockerfile>/Dockerfile), if no, type N:"
read dockerfile_path
if [[ "$dockerfile_path" != "N" ]]; then
	#Wait for docker-compose and then do static analysis
	static=true
fi
echo ""

#Docker-Compose
echo "Is there a docker-compose.yml to provide?"
echo "If yes, give the full path to docker-compose.yml (<path_to_yml>/docker-compose.yml), if no, type N:"
read yml_path
if [[ "$yml_path" == "N" ]]; then
	if $static ; then
		python static_parser.py ${dockerfile_path} empty_file
	fi
else
	if $static ; then
		python static_parser.py ${dockerfile_path} ${yml_path}
	else
		python static_parser.py empty_file ${yml_path}
	fi
fi
rm empty_file
echo ""

#Dynamic part requirements
echo "Give the number of services that need a profile for your project:"
read num_of_services
echo ""
echo "Give the name of each service (one per line):"
x=0
x_str=${x}
service_list="("
while [[ "$num_of_services" != $x_str ]] ; do
	read service
	service_list+=${service}
	service_list+=" "
	((x++))
	x_str=${x}
done
service_list+=")"

#We have the service list ready
#Sed every script that needs them
file_list=(2_cp_to_apparmor.sh*6s 3_load_profiles.sh*4s 4a_complain_mode.sh*4s 4b_enforce_mode.sh*4s 9_logging_files.sh*14s 10a_awk_it_complain.sh*10s 10b_awk_it_enforce.sh*10s 12_complain_enforce_audit.sh*5s)
for f_i in  "${file_list[@]}"; do
	file_i=$(echo $f_i | cut -d'*' -f1)
	line=$(echo $f_i | cut -d'*' -f2)
	sed -i "${line}/service_list=(.*/service_list=${service_list}/" dynamic_scripts/${file_i}
done
echo ""

#Define if network needed
echo "Do you need to create a docker network for your images?"
echo "If yes, specify network's name, if no, type N:"
read net
#Fix 6_net.sh
if [[ "$net" != "N" ]]; then
	sed -i "4s/net=.*/net=true/" dynamic_scripts/6_net.sh
	sed -i "6s/create .*/create ${net}/" dynamic_scripts/6_net.sh
fi
echo ""

#define run - testplan.sh
echo "In the next lines please give a testplan that you want to execute inside the container. Give a command per line, including the docker run commands or docker-compose commands with which you will start your container/containers."
echo "Type Done when you're finished"
echo "Remember, you are the one who knows how your program works. The commands will be executed in a script, so take all the actions needed to make it work."

while true; do
	#loop until Done
	commands="_"
	testplan="#!/bin/bash\n\n"
	while [[ "$commands" != "Done" ]] ; do
		read commands
		testplan+=${commands}
		testplan+=\n
	done
	echo ""
	echo "The script that will be used as a test plan for your project is given below:"
	echo ""
	echo "$testplan" > run.sh
	cat run.sh
	echo ""
	echo "Is the script corresponding to your test plan? [Y/N]"
	read ready
	if [[ "$ready" == "N" ]]; then
		echo "Please give again the commands you want to execute inside the container. Give a command per line, including the docker run commands or docker-compose commands with which you will start your container/containers."
		echo "Type Done when you're finished"
		echo "Remember, you are the one who knows how your program works. The commands will be executed in a script, so take all the actions needed to make it work."
	else
		break
	fi
done
echo ""
