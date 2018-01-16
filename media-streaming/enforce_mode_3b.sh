#!/bin/sh

#If profiles are in complain mode, turn them in enforce mode
sudo aa_enforce /etc/apparmor.d/dataset_profile
sudo aa_enforce /etc/apparmor.d/server_profile
sudo aa_enforce /etc/apparmor.d/client_profile
