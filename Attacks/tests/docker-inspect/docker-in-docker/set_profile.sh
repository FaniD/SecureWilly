#!/bin/sh

#Write profile to apparmor
sudo cp inspect_attack /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/inspect_attack

sudo cp inspect_attacker /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/inspect_attacker
