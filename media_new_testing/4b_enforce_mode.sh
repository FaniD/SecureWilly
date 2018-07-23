#!/bin/sh

#If profiles are in complain mode, turn them in enforce mode
sudo aa-enforce /etc/apparmor.d/dataset_profile
sudo aa-enforce /etc/apparmor.d/server_profile
sudo aa-enforce /etc/apparmor.d/client_profile
