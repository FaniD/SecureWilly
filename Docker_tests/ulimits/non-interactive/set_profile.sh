#!/bin/sh

#Write profile to apparmor
sudo cp ulimitn_prof /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/ulimitn_prof
