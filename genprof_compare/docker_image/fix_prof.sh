#!/bin/sh
sudo cp comparing_genprof_profile_v7 /etc/apparmor.d/
sudo apparmor_parser -r -W /etc/apparmor.d/comparing_genprof_profile_v7
sudo aa-enforce /etc/apparmor.d/comparing_genprof_profile_v7
