#!/bin/sh
read version 
sudo cp profiles/client/version_${version} /etc/apparmor.d/
sudo mv /etc/apparmor.d/version_${version} /etc/apparmor.d/client_profile
