#!/bin/sh

#Write profile to apparmor
sudo cp ulimit_prof /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/ulimit_prof
