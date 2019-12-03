#!/bin/bash

mkdir -pv /home/fanilicious/Projects/SecureWilly/MatterMost/volumes/app/mattermost/{data,logs,config,plugins,client-plugins}
docker-compose up
sudo chown -R 1000:1000 /home/fanilicious/Projects/SecureWilly/MatterMost/volumes/app/mattermost/
sudo chown -R 1000:1000 /home/fanilicious/Projects/SecureWilly/MatterMost/volumes
docker-compose up

#sudo sed -i "595s,.*,," volumes/db/
#sudo sed -i "595s,.*,," volumes/db/
#sudo sed -i "595s,.*,," volumes/db/

#mattermost user create --firstname Willy --system_admin --email faniliciousd@gmail.com --username willy --password secret
#mattermost team create --name SW --display_name "SecureWilly Team"
#mattermost team add SW faniliciousd@gmail.com willy

