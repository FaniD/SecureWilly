#!/bin/sh

sudo rm -r /home/ubuntu/SecureWilly/Nextcloud/data
mkdir /home/ubuntu/SecureWilly/Nextcloud/data
sudo chown www-data:www-data /home/ubuntu/SecureWilly/Nextcloud/data

docker-compose up -d
sleep 30
./testplan.sh
