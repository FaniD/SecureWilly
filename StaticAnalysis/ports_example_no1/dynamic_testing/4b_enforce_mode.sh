#!/bin/sh

#If profiles are in complain mode, turn them in enforce mode
sudo aa-enforce /etc/apparmor.d/server_profile
