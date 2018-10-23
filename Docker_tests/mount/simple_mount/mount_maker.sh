#!/bin/sh

#Write profile to apparmor
sudo cp simple_mount /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/simple_mount
