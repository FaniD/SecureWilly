#!/bin/sh

#Write profile to apparmor
sudo cp attacker_profile /etc/apparmor.d/
sudo apparmor_parser -r -W /etc/apparmor.d/attacker_profile
