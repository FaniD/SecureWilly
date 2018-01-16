#!/bin/sh
sudo aa_complain /etc/apparmor.d/dataset_profile
sudo aa_complain /etc/apparmor.d/server_profile
sudo aa_complain /etc/apparmor.d/client_profile
