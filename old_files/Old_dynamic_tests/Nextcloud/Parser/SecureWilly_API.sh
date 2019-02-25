#!/bin/bash

#Change this with the services I have each time
#Also do that in 2_cp, 3, 4a, 4b, 9, 10a, 10b, 12, metrics 

app_run_path=".."
parser_path="${app_run_path}/Parser"
dynamic_script_path="${parser_path}/dynamic_scripts"

echo "SecureWily"
echo "Copyright (c) 2019 Fani Dimou <fani.dimou92@gmail.com>"
echo ""
echo "Is there a Dockerfile to provide?"
echo "If yes, give path to Dockerfile (<path_to_dockerfile>/Dockerfile), if no, type N:"
read dockerfile_path

echo "Is there a docker-compose.yml to provide?"
echo "If yes, give path to docker-compose.yml (<path_to_yml>/docker-compose.yml), if no, type N:\n"
read yml_path
#An den exeis docker compose rota
echo "Give number of services that need a profile for your project:\n"
read num_of_services
echo "Give the name of each service:"
read servicei
service_list="(ser1 ser2)"
#read services and sed every script that needs them
#define if network needed
echo "Do you need a network for your images?"
echo "If yes, specify name, if no, type N:"
#define run - testplan.sh
echo "In the next lines please give a testplan that you want to execute inside the container. Give a command per line, including the docker run commands or docker-compose commands with which you will start your container/containers."
echo "Type Done when you're finished"
#loop until Done
