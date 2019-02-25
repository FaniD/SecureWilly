#!/bin/sh
read version 
sudo cp profiles/dataset/version_${version} /etc/apparmor.d/
sudo mv /etc/apparmor.d/version_${version} /etc/apparmor.d/dataset_profile
sudo cp profiles/server/version_${version} /etc/apparmor.d/
sudo mv /etc/apparmor.d/version_${version} /etc/apparmor.d/server_profile
sudo cp profiles/client/version_${version} /etc/apparmor.d/
sudo mv /etc/apparmor.d/version_${version} /etc/apparmor.d/client_profile
