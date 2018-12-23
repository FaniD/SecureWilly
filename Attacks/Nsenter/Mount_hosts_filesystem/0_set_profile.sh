#!/bin/sh

sudo cp attacked_container_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/attacked_container_profile

sudo cp attacker_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/attacker_profile
