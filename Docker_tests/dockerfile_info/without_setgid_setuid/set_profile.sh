#!/bin/sh

#Write profile to apparmor
sudo cp missing_caps /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/missing_caps
