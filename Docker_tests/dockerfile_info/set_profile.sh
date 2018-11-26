#!/bin/sh

#Write profile to apparmor
sudo cp dockerinfo /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/dockerinfo
