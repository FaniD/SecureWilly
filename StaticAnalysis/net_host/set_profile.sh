#!/bin/sh

#Write profile to apparmor
sudo cp net_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/net_profile
