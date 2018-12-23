#!/bin/sh

#Write profile to apparmor
sudo cp golden_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/golden_profile
