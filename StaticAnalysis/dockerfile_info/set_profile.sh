#!/bin/sh

#Write profile to apparmor
sudo cp dockerfile_info_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/dockerfile_info_profile
