#!/bin/bash

mkdir -pv /home/fanilicious/Projects/SecureWilly/MatterMost/volumes/app/mattermost/{data,logs,config,plugins,client/plugins}
sudo chown -R 1000:1000 /home/fanilicious/Projects/SecureWilly/MatterMost/volumes/app/mattermost/
docker-compose up
sleep 20
docker exec matterapp mattermost user create --firstname Willy --system_admin --email faniliciousd@gmail.com --username willy --password secret12345_SW
docker exec matterapp mattermost team create --name securewilly --display_name "SecureWilly Team"
docker exec matterapp mattermost team add securewilly faniliciousd@gmail.com willy

