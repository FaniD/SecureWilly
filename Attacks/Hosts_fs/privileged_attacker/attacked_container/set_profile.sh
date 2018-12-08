#!/bin/sh

#Write profile to apparmor
sudo cp attacked_container/attacked_container_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/attacked_container_profile
