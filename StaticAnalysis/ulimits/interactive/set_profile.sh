#!/bin/sh

#Write profile to apparmor
sudo cp ulimit_ti_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/ulimit_ti_profile
