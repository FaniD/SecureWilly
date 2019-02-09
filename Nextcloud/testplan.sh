#!/bin/sh

#Configure nextcloud
docker exec -u www-data -ti nextcloud_securewilly php occ maintenance:install --database "mysql" --database-name "nextcloud" --database-host "db" --database-user "willy" --database-pass "secret" --admin-user "willy" --admin-pass "secret"

#Create a file in local data directory
sudo touch data/willy/files/HelloFromTheOtherSide

#Use occ files:scan to make it visible to the web interface
docker exec -u www-data -ti nextcloud_securewilly php occ files:scan --all

#Enter bash shell
#docker exec -u www-data -ti nextcloud_securewilly /bin/bash
