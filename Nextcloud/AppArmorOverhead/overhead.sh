#!/bin/bash

#Count time while running Nextcloud services with SecureWilly's profiles enabled

#Load the profiles into kernel
service_list=(db nextcloud)
for SERVICE in "${service_list[@]}"; do
	sudo cp parser_output/${SERVICE}_profile /etc/apparmor.d/
	sudo apparmor_parser -r -W /etc/apparmor.d/${SERVICE}_profile
done

#execute test plan
sed -i "10s,#,," docker-compose.yml
sed -i "11s,#,," docker-compose.yml
sed -i "23s,#,," docker-compose.yml
sed -i "24s,#,," docker-compose.yml
time (./test_plan.sh) 2> securewilly_profiles
cat securewilly_profiles >> time_nc
