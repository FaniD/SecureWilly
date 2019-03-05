#!/bin/sh

#Write profile to apparmor
sudo cp genprof_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/genprof_profile
