#!/bin/sh
#echo 'Give version number of profile for each service'
read version
sudo cp profiles/server/version_${version} /etc/apparmor.d/
sudo mv /etc/apparmor.d/version_${version} /etc/apparmor.d/server_profile
sudo cp profiles/client/version_${version} /etc/apparmor.d/
sudo mv /etc/apparmor.d/version_${version} /etc/apparmor.d/client_profile

