#!/bin/bash

source Parser/timer.sh

t=$(timer)

IP=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
docker run -d -t -p 4443:4443 -p 443:443 -p 80:80 -v ncdata:/data nextcloudpi $IP
echo "Activation page . . ."
sleep 60
export MOZ_HEADLESS=1
sleep 60
./../../tests/activation_tests.py ${IP}
sudo touch /var/lib/docker/volumes/ncdata/_data/nextcloud/data/ncp/files/hello_world
docker exec nextcloudpi /usr/local/bin/ncp-scan
docker kill nextcloudpi
docker rm nextcloudpi
docker volume rm ncdata
docker rm nextcloudpi

total=$(timer $t)
echo "${total}" > unconfined_time
