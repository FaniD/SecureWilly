#!/bin/sh
#Write profile to apparmor
sudo cp static_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/static_profile
