#!/bin/sh

#Write profile to apparmor
sudo cp socket_attacked /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/socket_attacked

sudo cp socket_attacker /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/socket_attacker
