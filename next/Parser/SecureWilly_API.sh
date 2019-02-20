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
echo ""

#~~~Dynamic part requirements~~~
echo "Give the number of services that need a profile for your project:"
read num_of_services
echo ""
echo "Give the name of each service following the next rules:"
echo "1. The names should not be used for other purposes like named volumes, network etc"
echo "2. If you provided a docker-compose.yml, make sure that you give the same names of services you used inside the yml file and with the same order as they are in it."
echo "3. If you didn't provide a docker-compose.yml, the service name should be the same with the image you mention in the docker run command."
echo "4. Give one name per line."
x=0
x_str=${x}
service_list="("
services=""
while true; do
	read service

	#services string will be used to create an array of the services in this script
	services+=${service}

	#service_list will be used as a string by sed to insert the services in dynamic_scripts
	service_list+=${service}

	((x++))
	x_str=${x}
	if [[ "$num_of_services" == $x_str ]] ; then
		break
	fi
	service_list+=" "
	services+=","
done
service_list+=")"

#We have the service list ready
#Sed every script that needs them
#Dynamic parser seds alone because of its different path
sed -i "5s/service_list=(.*/service_list=${service_list}/" dynamic_parser.sh
file_list=(2_cp_to_apparmor.sh*6s 3_load_profiles.sh*4s 4a_complain_mode.sh*4s 4b_enforce_mode.sh*4s 8_logging_files.sh*15s 9_clear_containers.sh*9s 10a_awk_it_complain.sh*10s 10b_awk_it_enforce.sh*10s 12_complain_enforce_audit.sh*5s)
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
		rm run.sh
		echo "Please give again the commands you want to execute inside the container."
		echo "Make sure you follow the next rules:"
		echo "1. Give a command per line."
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
#If docker-compose does not exist, make sure to fix the script so that it includes security-opt flag and create mini docker compose files for each service
	for service_i in "${array[@]}"; do
		#Add security-opt flag
		sed -i "/docker run/ s/${service_i}/${service_i} --security-opt "apparmor=${service_i}_profile"/" dynamic_scripts/7_run.sh

		#Convert flags into docker-compose files

		#Separate docker run commands for each service
		grep -E "docker run.*${service_i}" dynamic_scripts/7_run.sh > ${service_i}_run

		#Find ports
		awk '/ -p / {for(i=1;i<=NF;i++) {if($i ~ /-p/) print $(i+1)}}' ${service_i}_run > ${service_i}_ports
		sed -i 's/"//g' ${service_i}_ports

		#Find volumes
		awk '/ -v / {for(i=1;i<=NF;i++) {if($i ~ /-v/) print $(i+1)}}' ${service_i}_run > ${service_i}_volumes
		sed -i 's/"//g' ${service_i}_volumes

		#Find capabilities added
		awk '/ --cap-add / {for(i=1;i<=NF;i++) {if($i ~ /--cap-add/) print $(i+1)}}' ${service_i}_run > ${service_i}_capadds
		sed -i 's/"//g' ${service_i}_capadds

		#Find capabilities dropped
		awk '/ --cap-drop / {for(i=1;i<=NF;i++) {if($i ~ /--cap-drop/) print $(i+1)}}' ${service_i}_run > ${service_i}_capdrops
		sed -i 's/"//g' ${service_i}_capdrops

		#Find ulimit
		awk '/ --ulimit / {for(i=1;i<=NF;i++) {if($i ~ /--ulimit/) print $(i+1)}}' ${service_i}_run > ${service_i}_ulimits
		sed -i 's/"//g' ${service_i}_ulimits

		rm ${service_i}_run

		#Start creating mini docker-compose.yml
		echo "${service_i}:" > ${service_i}_yml
	
		#Ports
		wc_ports=$(wc -l ${service_i}_ports | cut -d' ' -f1)
		if [[ "$wc_ports" != "0" ]]; then
			echo " ports:" >> ${service_i}_yml
			sed -i 's/.*/  - "&"/g' ${service_i}_ports
			cat ${service_i}_ports >> ${service_i}_yml
		fi
		rm ${service_i}_ports
		

		#Volumes
                wc_volumes=$(wc -l ${service_i}_volumes | cut -d' ' -f1)
		if [[ "$wc_volumes" != "0" ]]; then
			echo " volumes:" >> ${service_i}_yml
			sed -i 's/.*/  - "&"/g' ${service_i}_volumes
			cat ${service_i}_volumes >> ${service_i}_yml
		fi
		rm ${service_i}_volumes

		#Cap_add
                wc_capadds=$(wc -l ${service_i}_capadds | cut -d' ' -f1)
		if [[ "$wc_capadds" != "0" ]]; then
			echo " cap_add:" >> ${service_i}_yml
			sed -i 's/.*/  - &/g' ${service_i}_capadds
			cat ${service_i}_capadds >> ${service_i}_yml
		fi
		rm ${service_i}_capadds

                #Cap_drop
		wc_capdrops=$(wc -l ${service_i}_capdrops | cut -d' ' -f1)
		if [[ "$wc_capdrops" != "0" ]]; then
			echo " cap_drop:" >> ${service_i}_yml
			sed -i 's/.*/  - &/g' ${service_i}_capdrops
			cat ${service_i}_capdrops >> ${service_i}_yml
		fi
		rm ${service_i}_capdrops

		#Ulimits
                wc_ulimits=$(wc -l ${service_i}_ulimits | cut -d' ' -f1)
		if [[ "$wc_ulimits" != "0" ]]; then
			echo " ulimits:" >> ${service_i}_yml
			cut -d'=' -f1 ${service_i}_ulimits > name_ul
			cut -d'=' -f2 ${service_i}_ulimits > soft_hard
			cut -d':' -f1 soft_hard > soft_ul
			cut -d':' -f2 soft_hard > hard_ul
                        sed 's/.*/  &:/g' name_ul >> ${service_i}_yml
			sed 's/.*/   soft:&/g' soft_ul >> ${service_i}_yml
			sed 's/.*/   hard:&/g' hard_ul >> ${service_i}_yml
			rm name_ul
			rm soft_hard
			rm soft_ul
			rm hard_ul
		fi
                rm ${service_i}_ulimits
	done
else
#If docker-compose.yml exists, add security-opt and create mini docker compose files for each service

	yml_lines=$(wc -l ${yml_path} | cut -d' ' -f1)

	#Find lines of each service block so that mini service docker-compose files are created
	service_start=$(awk '/services/ {print NR}' ${yml_path})
	num_start=""
	for service_i in "${array[@]}"; do
	       num_start+=$(awk "${service_start}<NR && /${service_i}:/ {print NR}" ${yml_path} | head -n 1)
	       num_start+=","
	done

	IFS=',' read -r -a array_ <<< "$num_start"
	y=1 #Count the lines that are added
	z=0 #Count loops
	x=1
	for i in "${array_[@]}"; do
		start_old=${start_position}
		#x will show where to add the new line
		x=$(expr $i + $y)
		
		#String of the next line of each service
		var1="$(< ${yml_path} sed -n "${x}s/ *//p")"
		
		#Index of non whitespace string of next line 
		#indx=$(awk -v p="$var1" 'index($0,p) {s=$0; m=0; while((n=index(s, p))>0) {m+=n; printf "%s ", m; s=substr(s, n+1) } print ""}' ${yml_path})

		xx=$(expr $x + 1)
		#Duplicate the after service name next line
		sed -i "${x}s/\([^.]*\)/&\n\1/" ${yml_path}
		sed -i "${x}s/\([^.]*\)/&\n\1/" ${yml_path}

		#Security-opt
		#Write the new line on this line so that the syntax stays the same
		sed -i "${x}s/${var1}/security_opt:/" ${yml_path}
		sed -i "${xx}s/${var1}/  - \"apparmor:${array[${z}]}_profile\"/" ${yml_path}

		#Mini docker-compose files
		lp=$(expr $z + 1)
		loops=$(echo "$lp")
		previous_z=$(expr $z - 1)
		start_position=$(expr $x - 1)
		start_minus=$(expr $start_position - 1)
		if [[ "$loops" == $num_of_services ]]; then
			#Last service's docker-compose.yml
			sed -e "1,${start_minus}d" ${yml_path} > ${array[${z}]}_yml
			#Previous service's docker-compose.yml
			sed -n "${start_old},${start_minus}p" ${yml_path} > ${array[${previous_z}]}_yml
		elif [[ "$loops" != "1" ]]; then
			#Previous service's docker-compose.yml
			sed -n "${start_old},${start_minus}p" ${yml_path} > ${array[${previous_z}]}_yml
		fi
		lpp=$(expr $lp \* 2)
		y=$(expr $y + $lpp)
		((z++))
	done
fi

#Run static_parser.py
if [ "$static" = false ] ; then
	dockerfile_path="empty_file"
fi

mkdir ${app_run_path}/parser_output

for service_i in "${array[@]}"; do
	echo "" >> ${service_i}_yml
	python static_parser.py ${dockerfile_path} ${service_i}_yml
	sed -i "3s/static_profile/${service_i}_profile/" static_profile
	mv static_profile ${app_run_path}/parser_output/${service_i}_profile
done

rm empty_file

#Dynamic_parser
#./dynamic_parser.sh

echo "Profiles produced for all services are located in parser_output directory."
