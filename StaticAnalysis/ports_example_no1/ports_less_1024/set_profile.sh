#!/bin/sh

#Write profile to apparmor
sudo cp ports_1_well_known /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/ports_1_well_known
