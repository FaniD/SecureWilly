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

#Dynamic part requirements
echo "Give the number of services that need a profile for your project:"
read num_of_services
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


#Define if network needed
echo "Do you need a network for your images?"
echo "If yes, specify network's name, if no, type N:"
read net
#Fix 6_net.sh

#define run - testplan.sh
echo "In the next lines please give a testplan that you want to execute inside the container. Give a command per line, including the docker run commands or docker-compose commands with which you will start your container/containers."
echo "Type Done when you're finished"
echo "Remember, you are the one who knows how your program works. The commands will be executed in a script, so take all the actions needed to make it work."
#loop until Done
commands="_"
testplan="#!/bin/bash\n\n"
while [[ "$commands" != "Done" ]] ; do
	read commands
	testplan+=${commands}
	testplan+=\n
done
echo "$testplan" > run.sh
