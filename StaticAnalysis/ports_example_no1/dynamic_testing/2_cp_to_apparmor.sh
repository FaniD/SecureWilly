#!/bin/sh
read version 
sudo cp profiles/server/version_${version} /etc/apparmor.d/
sudo mv /etc/apparmor.d/version_${version} /etc/apparmor.d/server_profile
