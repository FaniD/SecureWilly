#!/bin/sh
sudo apparmor_parser -r -W /etc/apparmor.d/dataset_profile
sudo apparmor_parser -r -W /etc/apparmor.d/server_profile
sudo apparmor_parser -r -W /etc/apparmor.d/client_profile
