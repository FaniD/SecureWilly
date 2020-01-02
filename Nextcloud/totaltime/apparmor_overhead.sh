#!/bin/bash

source Parser/timer.sh

t=$(timer)

sudo rm -r /home/fanilicious/Projects/SecureWilly/Nextcloud/totaltime/data
mkdir /home/fanilicious/Projects/SecureWilly/Nextcloud/totaltime/data
sudo chown http:http /home/fanilicious/Projects/SecureWilly/Nextcloud/totaltime/data -R

# Start containers
docker-compose up -d
sudo chown http:http /var/lib/docker/volumes/totaltime_nextcloud_ -R
sleep 20

# Check server status
echo "=== Check server status ==="
docker exec -u www-data nextcloud php /var/www/html/occ status > status_answer 2> status_error_exec
status_answer=$(cat status_answer | grep 'Nextcloud is not installed')
status_error_exec=$(cat status_answer | grep 'is not running')
while [ -z "$status_answer" ] && [ ! -z "$status_error_exec" ]
do
        rm status_*
        docker exec -u www-data nextcloud php /var/www/html/occ status > status_answer 2> status_error_exec
        status_answer=$(cat status_answer | grep 'Nextcloud is not installed')
	status_error_exec=$(cat status_answer | grep 'is not running')
done
rm status_*

sleep 20

# Check db status
# Error while trying to create admin user
echo "=== Check db status ==="
docker exec db mysql -u nextcloud -p'secret' > mysql_answer 2> mysql_error_exec
mysql_error_exec=$(cat mysql_error_exec | grep 'ERROR')
while [ ! -z "$mysql_error_exec" ]
do
  rm mysql_*
  docker exec db mysql -u nextcloud -p'secret' > mysql_answer 2> mysql_error_exec
  mysql_error_exec=$(cat mysql_error_exec | grep 'ERROR')
done
rm mysql_*

# Configure nextcloud
echo "=== Install nextcloud ==="
# Expect to get Nextcloud was successfully installed
docker exec -u www-data nextcloud php /var/www/html/occ maintenance:install --database "mysql" --database-name "nextcloud" --database-host "db" --database-user "nextcloud" --database-pass "secret" --admin-user "nextcloud" --admin-pass "secret"

# Create a file in local data directory
sudo touch /home/fanilicious/Projects/SecureWilly/Nextcloud/totaltime/data/nextcloud/files/HelloFromTheOtherSide

# Use occ files:scan to make it visible to the web interface
echo "=== File scanning ==="
docker exec -u www-data nextcloud php /var/www/html/occ files:scan --all

docker kill nextcloud
docker kill db

total=$(timer $t)
echo "${total}" > apparmor_overhead
