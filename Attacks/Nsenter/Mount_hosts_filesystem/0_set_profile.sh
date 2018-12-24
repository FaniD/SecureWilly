#!/bin/sh

sudo cp attacked_container_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/attacked_container_profile

sudo cp attackerns_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/attackerns_profile
