#!/bin/sh

#Write profile to apparmor
sudo cp root_attacker /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/root_attacker
