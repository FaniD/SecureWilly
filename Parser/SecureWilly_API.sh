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

#~~~~~~~~~~~~Static Part requirements~~~~~~~~~~~~~~
#~~~Dockerfile~~~
echo "Is there a Dockerfile to provide?"
echo "If yes, give the full path to Dockerfile (<path_to_dockerfile>/Dockerfile), if no, type N:"
read dockerfile_path
if [[ "$dockerfile_path" != "N" ]]; then
	#Wait for docker-compose and then do static analysis
	static=true
fi
echo ""

#~~~Docker-Compose~~~
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

#~~~Dynamic part requirements~~~
echo "Give the number of services that need a profile for your project:"
read num_of_services
echo ""
echo "Give the name of each service - make sure the names are not used for other purpose like named volumes, network etc"
echo "If you provided a docker-compose.yml make sure that you give the same names of services you used inside the yml file."
echo "Give one name per line:"
x=0
x_str=${x}
service_list="("
services=""
while [[ "$num_of_services" != $x_str ]] ; do
	read service

	#services string will be used to create an array of the services in this script
	services+=${service}
	services+=","

	#service_list will be used as a string by sed to insert the services in dynamic_scripts
	service_list+=${service}
	service_list+=" "

	((x++))
	x_str=${x}
done
service_list+=")"

#We have the service list ready
#Sed every script that needs them
#Dynamic parser seds alone because of its different path
sed -i "5s/service_list=(.*/service_list=${service_list}/" dynamic_parser.sh
file_list=(2_cp_to_apparmor.sh*6s 3_load_profiles.sh*4s 4a_complain_mode.sh*4s 4b_enforce_mode.sh*4s 8_logging_files.sh*14s 10a_awk_it_complain.sh*10s 10b_awk_it_enforce.sh*10s 12_complain_enforce_audit.sh*5s)
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
#Fix 6_net.sh & 9_clear_containers.sh
if [[ "$net" != "N" ]]; then
	sed -i "4s/net=.*/net=true/" dynamic_scripts/6_net.sh
	sed -i "6s/create .*/create ${net}/" dynamic_scripts/6_net.sh

	sed -i "3s/net=.*/net=true/" dynamic_scripts/9_clear_containers.sh
	sed -i "6s/rm .*/rm ${net}/" dynamic_scripts/9_clear_containers.sh

fi
echo ""

#define run - testplan.sh
echo "In the next lines please give a testplan that you want to execute inside the container."
echo "Make sure you follow the next rules:"
echo "1. Give a command per line"
echo "2. Include the docker run commands or docker-compose commands with which you will start and stop your container(s)."
echo "3. Use the --name flag to run your containers and name them after the name of service you mentioned before."
echo "4. Do NOT use flag --security-opt to run your containers."
echo "5. Type Done when you're finished."
echo "Remember, you are the one who knows how your program works. The commands will be executed in a script, so take all the actions needed to make it work."

while true; do
	#loop until Done
	read commands
	echo "#!/bin/bash" > run.sh
	echo " " >> run.sh
	while [[ "$commands" != "Done" ]] ; do
		echo "${commands}" >> run.sh
		read commands
	done
	echo ""
	echo "The script that will be used as a test plan for your project is given below:"
	echo ""
	cat run.sh
	echo ""
	echo "Is the script corresponding to your test plan? [Y/N]"
	read ready
	if [[ "$ready" == "N" ]]; then
		echo "Please give again the commands you want to execute inside the container."
		echo "Make sure you follow the next rules:"
		echo "1. Give a command per line"
		echo "2. Include the docker run commands or docker-compose commands with which you will start and stop your container(s)."
		echo "3. Use the --name flag to run your containers and name them after the name of service you mentioned before."
		echo "4. Do NOT use flag --security-opt to run your containers."
		echo "5. Type Done when you're finished."
		echo "Remember, you are the one who knows how your program works. The commands will be executed in a script, so take all the actions needed to make it work."
	else
		break
	fi
done
echo ""
mv run.sh dynamic_scripts/7_run.sh

IFS=',' read -r -a array <<< "$services"
if [[ "$yml_path" == "N" ]]; then
#If docker-compose does not exist, make sure to fix the script so that it includes security-opt flag
	for service_i in "${array[@]}"; do
		sed -i "/docker run/ s/${service_i}/${service_i} --security-opt "apparmor=${service_i}_profile"/" dynamic_scripts/7_run.sh
	done
else
	#Find lines of each service block so that mini service docker-compose files are created
	service_start=$(awk '/services/ {print NR}' ${yml_path})
	num_start=""
	for service_i in "${array[@]}"; do
	       num_start+=$(awk "${service_start}<NR && /${service_i}:/ {print NR}" ${yml_path} | head -n 1)
	       num_start+=","
	done
	echo "Arxi twn services: ${num_start}"

	IFS=',' read -r -a array_ <<< "$num_start"
	y=1
	z=0
	for i in "${array_[@]}"; do
		x=$(expr $i + $y)
		#String of the next line of each service
		var1="$(< ${yml_path} sed -n "${x}s/ *//p")"
		indx=$(awk -v p="$var1" 'index($0,p) {s=$0; m=0; while((n=index(s, p))>0) {m+=n; printf "%s ", m; s=substr(s, n+1) } print ""}' ${yml_path})

		echo "Index of image ${indx}. Prepei na nai 9"
#		sed -i "${x}i security_opt: apparmor:${array[${z}]}_profile" ${yml_path}
		((y++))
		((z++))
		echo "Meta to ++ ${y}"
	done
fi
