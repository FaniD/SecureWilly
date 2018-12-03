#!/bin/sh

#Write profile to apparmor
sudo cp ro_vol /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/ro_vol
