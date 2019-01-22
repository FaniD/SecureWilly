#!/bin/sh

#Write profile to apparmor
sudo cp spc_attacker /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/spc_attacker
