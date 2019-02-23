#!/bin/bash

#Change this with the services I have each time
#Also do that in 2_cp, 3, 4a, 4b, 9, 10a, 10b, 12, metrics 

app_run_path=".."
parser_path="${app_run_path}/Parser"
dynamic_script_path="${parser_path}/dynamic_scripts"

touch empty_file

echo "SecureWily"
echo "Copyright (c) 2019 Fani Dimou <fani.dimou92@gmail.com>"
echo ""

#~~~~~~~~~~~~Static Part requirements~~~~~~~~~~~~~~

#~~~Dynamic part requirements~~~
echo "Give the number of services that need a profile for your project:"
echo "A service is defined by a docker image, either it is built by Dockerfile or uses an existing image, with or without docker-compose file."
read num_of_services
echo ""
echo "Give the name of each service following the next rules:"
echo "1. The names should not be used for other purposes like named volumes, network etc"
echo "2. If you use a docker-compose.yml, make sure that you give the same names of services you used inside the yml file and with the same order as they are in it."
echo "3. Names of services should be identical to the names of the corresponding images."
echo "   Do not worry about special characters, just give the exact same name of the image and let SecureWilly worry about it." # Make sure to name your containers either in docker-container using container_name or in the testplan commands with flag --name."
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
echo "${service_list}" > a
sed -i "s,/,,g" a
sed -i "s,:,,g" a
service_list_noslash=$(cat a)
rm a
echo "${services}" > a
sed -i "s,/,,g" a 
sed -i "s,:,,g" a
services_noslash=$(cat a)
rm a

#Services in arrays
IFS=',' read -r -a array <<< "$services"
IFS=',' read -r -a array_noslash <<<"$services_noslash"

#~~~Dockerfile~~~
dcrf=0
for service_i in "${array[@]}"; do 
	echo "Is there a Dockerfile to provide for image ${service_i}?"
	echo "If yes, give the full path to Dockerfile (<path_to_dockerfile>/Dockerfile), if no, type N:"
	read dockerfile_path
	if [[ "$dockerfile_path" == "N" ]]; then
		#Wait for docker-compose and then do static analysis
		touch ${array_noslash[${dcrf}]}_dockerfile_path
	else
		cat ${dockerfile_path} > ${array_noslash[${dcrf}]}_dockerfile_path
	fi
	((dcrf++))
done
echo ""

#~~~Docker-Compose~~~
echo "Is there a docker-compose.yml to provide?"
echo "If yes, give the full path to docker-compose.yml (<path_to_yml>/docker-compose.yml), if no, type N:"
read yml_path
sed -i "20s/yml=.*/yml=false/" dynamic_scripts/9_clear_containers.sh
if [[ "$yml" != "N" ]]; then
	sed -i "20s/yml=.*/yml=true/" dynamic_scripts/9_clear_containers.sh
fi
echo ""

#We have the service list ready
#Sed every script that needs them
#Dynamic parser seds alone because of its different path
sed -i "5s,service_list=(.*,service_list=${service_list_noslash}," dynamic_parser.sh
file_list=(2_cp_to_apparmor.sh*6s 3_load_profiles.sh*4s 4a_complain_mode.sh*4s 4b_enforce_mode.sh*4s 8_logging_files.sh*15s 10a_awk_it_complain.sh*10s 10b_awk_it_enforce.sh*10s 12_complain_enforce_audit.sh*5s)
for f_i in  "${file_list[@]}"; do
	file_i=$(echo $f_i | cut -d'*' -f1)
	line=$(echo $f_i | cut -d'*' -f2) #line var includes s for sed
	sed -i "${line},service_list=(.*,service_list=${service_list_noslash}," dynamic_scripts/${file_i}
done
echo ""

#Define if network needed
echo "Do you need to create a docker network for your images?"
echo "If yes, specify network's name, if no, type N:"
read net
#Fix 6_net.sh & 9_clear_containers.sh
sed -i "4s/net=.*/net=false/" dynamic_scripts/6_net.sh
sed -i "3s/net=.*/net=false/" dynamic_scripts/9_clear_containers.sh
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
echo "3. If no docker-compose is used, it is wise to use the --name flag to run your containers. If you do not do that, SecureWilly will name your containers after the corresponding service name."
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
		echo "3. If no docker-compose is used, it is wise to use the --name flag to run your containers. If you do not do that, SecureWilly will name your containers after the corresponding service name."
		echo "4. Do NOT use flag --security-opt to run your containers."
		echo "5. Type Done when you're finished."
		echo "Remember, you are the one who knows how your program works. The commands will be executed in a script, so take all the actions needed to make it work."
	else
		break
	fi
done
echo ""
mv run.sh dynamic_scripts/7_run.sh

containers="("
if [[ "$yml_path" == "N" ]]; then
#If docker-compose does not exist, make sure to fix the script so that it includes security-opt flag and create mini docker compose files for each service
	yml_count=0
	for service_i in "${array[@]}"; do
		#Add security-opt flag
		sed -i "/docker create/ s,${service_i},--security-opt \"apparmor=${array_noslash[${yml_count}]}_profile\" ${service_i}," dynamic_scripts/7_run.sh
		sed -i "/docker run/ s,${service_i},--security-opt \"apparmor=${array_noslash[${yml_count}]}_profile\" ${service_i}," dynamic_scripts/7_run.sh

		#Convert flags into docker-compose files

		#Separate docker run commands for each service
		grep -E "docker run.*${service_i}" dynamic_scripts/7_run.sh > run
		grep -E "docker create.*${service_i}" dynamic_scripts/7_run.sh >> run

		#Does the docker run and create have named containers?
		awk '/ --name / {for(i=1;i<=NF;i++) {if($i ~ /--name/) print $(i+1)}}' run > name
		wc_name=$(wc -l name | cut -d' ' -f1)
		if [[ "$yml_count" != 0 ]]; then
			containers+=" "
		fi
		if [[ "$wc_name" == "0" ]]; then
			containers+="${array_noslash[${yml_count}]}"
			sed -i "/docker create/ s,${service_i},--name ${array_noslash[${yml_count}]} ${service_i}," dynamic_scripts/7_run.sh
			sed -i "/docker run/ s,${service_i},--name ${array_noslash[${yml_count}]} ${service_i}," dynamic_scripts/7_run.sh
		else
			containers+=$(cat name)
		fi
		rm name

		#Find ports
		awk '/ -p / {for(i=1;i<=NF;i++) {if($i ~ /-p/) print $(i+1)}}' run > ports
		sed -i 's,",,g' ports

		#Find volumes
		sed 's,--volumes-from,,g' run > run_vol
		awk '/ -v / {for(i=1;i<=NF;i++) {if($i ~ /-v/) print $(i+1)}}' run_vol > volumes
		sed -i 's,",,g' volumes
		rm run_vol

		#Find capabilities added
		awk '/ --cap-add / {for(i=1;i<=NF;i++) {if($i ~ /--cap-add/) print $(i+1)}}' run > capadds
		sed -i 's,",,g' capadds

		#Find capabilities dropped
		awk '/ --cap-drop / {for(i=1;i<=NF;i++) {if($i ~ /--cap-drop/) print $(i+1)}}' run > capdrops
		sed -i 's,",,g' capdrops

		#Find ulimit
		awk '/ --ulimit / {for(i=1;i<=NF;i++) {if($i ~ /--ulimit/) print $(i+1)}}' run > ulimits
		sed -i 's,",,g' ulimits

		rm run

		#Start creating mini docker-compose.yml
		echo "${service_i}:" > ${array_noslash[${yml_count}]}_yml
	
		#Ports
		wc_ports=$(wc -l ports | cut -d' ' -f1)
		if [[ "$wc_ports" != "0" ]]; then
			echo " ports:" >> ${array_noslash[${yml_count}]}_yml
			sed -i 's,.*,  - "&",g' ports
			cat ports >> ${array_noslash[${yml_count}]}_yml
		fi
		rm ports
		

		#Volumes
                wc_volumes=$(wc -l volumes | cut -d' ' -f1)
		if [[ "$wc_volumes" != "0" ]]; then
			echo " volumes:" >> ${array_noslash[${yml_count}]}_yml
			sed -i 's,.*,  - "&",g' volumes
			cat volumes >> ${array_noslash[${yml_count}]}_yml
		fi
		rm volumes

		#Cap_add
                wc_capadds=$(wc -l capadds | cut -d' ' -f1)
		if [[ "$wc_capadds" != "0" ]]; then
			echo " cap_add:" >> ${array_noslash[${yml_count}]}_yml
			sed -i 's,.*,  - &,g' capadds
			cat capadds >> ${array_noslash[${yml_count}]}_yml
		fi
		rm capadds

                #Cap_drop
		wc_capdrops=$(wc -l capdrops | cut -d' ' -f1)
		if [[ "$wc_capdrops" != "0" ]]; then
			echo " cap_drop:" >> ${array_noslash[${yml_count}]}_yml
			sed -i 's,.*,  - &,g' capdrops
			cat capdrops >> ${array_noslash[${yml_count}]}_yml
		fi
		rm capdrops

		#Ulimits
                wc_ulimits=$(wc -l ulimits | cut -d' ' -f1)
		if [[ "$wc_ulimits" != "0" ]]; then
			echo " ulimits:" >> ${array_noslash[${yml_count}]}_yml
			cut -d'=' -f1 ulimits > name_ul
			cut -d'=' -f2 ulimits > soft_hard
			cut -d':' -f1 soft_hard > soft_ul
			cut -d':' -f2 soft_hard > hard_ul
                        sed 's,.*,  &:,g' name_ul >> ${array_noslash[${yml_count}]}_yml
			sed 's,.*,   soft:&,g' soft_ul >> ${array_noslash[${yml_count}]}_yml
			sed 's,.*,   hard:&,g' hard_ul >> ${array_noslash[${yml_count}]}_yml
			rm name_ul
			rm soft_hard
			rm soft_ul
			rm hard_ul
		fi
                rm ulimits
		((yml_count++))
	done
	containers+=")"
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
			sed -e "1,${start_minus}d" ${yml_path} > ${array_noslash[${z}]}_yml #${array[${z}]}_yml
			#Previous service's docker-compose.yml
			if [[ "$num_of_services" != "1" ]]; then 
				sed -n "${start_old},${start_minus}p" ${yml_path} > ${array_noslash[${previous_z}]}_yml #${array[${previous_z}]}_yml
			fi
		elif [[ "$loops" != "1" ]]; then
			#Previous service's docker-compose.yml
			sed -n "${start_old},${start_minus}p" ${yml_path} > ${array_noslash[${previous_z}]}_yml #${array[${previous_z}]}_yml
		fi
		lpp=$(expr $lp \* 2)
		y=$(expr $y + $lpp)
		((z++))
	done
	
	lines_security=$(awk '/security_opt:/ {print NR}' ${yml_path})
	while IFS= read -r line ; do lines_secopt+="$line,"; done <<< "$lines_security"
	IFS=',' read -r -a lines_ar <<< "$lines_secopt"
	line=0
	line_=0
	for service_i in "${array_noslash[@]}"; do
		line_=$(expr ${lines_ar[${line}]} + ${line})
		#I search every mini yml to see if container name exists
		awk '/container_name:/ {for(i=1;i<=NF;i++) {if($i ~ /container_name:/) print $(i+1)}}' ${service_i}_yml > name
		wc_name=$(wc -l name | cut -d' ' -f1)
		if [[ "$line" != 0 ]]; then
			containers+=" "
		fi
		if [[ "$wc_name" == "0" ]]; then
		        containers+="${service_i}"
			#Duplicate the security opt line
			sed -i "${line_}s/\([^.]*\)/&\n\1/" ${yml_path}
			#Write the new line on this line so that the syntax stays the same
			sed -i "${line_}s/security.*/container_name: ${service_i}/" ${yml_path}
		else
			containers+=$(cat name)
		fi
		((line++))
		rm name
	done
	containers+=")"
	echo "${containers}"
fi

#Fix 9_clear_containers.sh to rm the selected containers
sed -i "9s,container_list=(.*,container_list=${containers}," dynamic_scripts/9_clear_containers.sh

mkdir ${app_run_path}/parser_output

current_dir=$(pwd | sed "s,/*[^/]\+/*$,," |  sed 's#.*/##' | sed 's/_//g' | sed "s/.*/\"&\"/")
sed -i "s/current_dir = .*/current_dir = ${current_dir}/" static_parser.py

yml_count=0
for service_i in "${array[@]}"; do
	echo "" >> ${array_noslash[${yml_count}]}_yml

	#Count volumes if exist
	#echo ${array_noslash[${yml_count}]}
	python find_vols.py ${array_noslash[${yml_count}]}_yml
	
	#This file is needed in dynamic_analysis
	mv if_vol if_vol_${array_noslash[${yml_count}]}

	#Run static parser
	python static_parser.py ${array_noslash[${yml_count}]}_dockerfile_path ${array_noslash[${yml_count}]}_yml

	#Fix profile's name
	sed -i "3s,static_profile,${array_noslash[${yml_count}]}_profile," static_profile
	mv static_profile ${app_run_path}/parser_output/${array_noslash[${yml_count}]}_profile

	#Keep yml files in parser output as it may come in handy for the user
	mv ${array_noslash[${yml_count}]}_yml ${app_run_path}/parser_output/${array_noslash[${yml_count}]}_yml
	#Delete dockerfiles as the user already has them
	rm ${array_noslash[${yml_count}]}_dockerfile_path
	((yml_count++))
done

rm empty_file

sudo chmod +x dynamic_scripts/7_run.sh
#Dynamic_parser
#./dynamic_parser.sh

for service_i in "${array_noslash[@]}"; do
	rm if_vol_${service_i}
done
echo "Profiles produced for all services are located in parser_output directory."
