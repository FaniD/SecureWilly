#!/bin/bash
 
mkdir -pv /home/fanilicious/Projects/SecureWilly/MatterMost/totaltime/volumes/app/mattermost/{data,logs,config,plugins,client-plugins}
sudo chown -R 1000:1000 /home/fanilicious/Projects/SecureWilly/MatterMost/totaltime/volumes/app/mattermost/
docker-compose up -d
sleep 20
docker exec app mattermost user create --firstname Willy --system_admin --email faniliciousd@gmail.com --username willy --password secret12345_SW
docker exec app mattermost team create --name securewilly --display_name "SecureWilly Team"
docker exec app mattermost team add securewilly faniliciousd@gmail.com willy
docker-compose down
docker volume prune -f
sudo rm -r volumes
