#!/bin/sh

#Write profile to apparmor
sudo cp mount_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/mount_profile
