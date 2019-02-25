#!/bin/sh
echo 'Give version number of profile for each service'
read server
read client
sudo cp profiles/server/version_${server}_s /etc/apparmor.d/server_profile
sudo cp profiles/client/version_${client}_c /etc/apparmor.d/client_profile

