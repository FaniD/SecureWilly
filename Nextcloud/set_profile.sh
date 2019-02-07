#!/bin/sh

#Write profile to apparmor
sudo cp nextcloud_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/nextcloud_profile
sudo aa-complain /etc/apparmor.d/nextcloud_profile
