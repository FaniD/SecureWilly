#!/bin/bash
 
sudo rm -r /home/fanilicious/Projects/SecureWilly/Nextcloud/data
mkdir /home/fanilicious/Projects/SecureWilly/Nextcloud/data
#sudo chown www-data:www-data /home/fanilicious/Projects/SecureWilly/Nextcloud/data
sudo chown http:http /home/fanilicious/Projects/SecureWilly/Nextcloud/data

# Start containers
docker-compose up -d
sleep 60

# Check server status
docker exec -u www-data nextcloud php occ status > answer
answer=$(cat answer | grep 'Nextcloud is not installed')
while [ -z "$answer" ] && [ ! -z "$error_exec" ]
do
rm answer
docker exec -u www-data nextcloud php occ status > answer 2> error_exec
answer=$(cat answer | grep 'Nextcloud is not installed')
error_exec=$(cat answer | grep 'is not running')
done
rm answer

# Check db status
# Error while trying to create admin user
docker exec db mysql -u nextcloud -p'secret' > answer 2> error_exec
error_exec=$(cat error_exec | grep 'ERROR')
while [ ! -z "$error_exec" ]
do
rm error_exec
docker exec db mysql -u nextcloud -p'secret' > answer 2> error_exec
error_exec=$(cat error_exec | grep 'ERROR')
done
rm error_exec

# Configure nextcloud
docker exec -u www-data nextcloud php occ maintenance:install --database "mysql" --database-name "nextcloud" --database-host "db" --database-user "nextcloud" --database-pass "secret" --admin-user "nextcloud" --admin-pass "secret"

# Create a file in local data directory
sudo touch /home/fanilicious/Projects/SecureWilly/Nextcloud/data/nextcloud/files/HelloFromTheOtherSide

# Use occ files:scan to make it visible to the web interface
docker exec -u www-data nextcloud php occ files:scan --all

docker kill nextcloud
docker kill db
