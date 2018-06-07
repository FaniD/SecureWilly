#!/bin/sh
sudo cp profile_created_by_genprof /etc/apparmor.d/
sudo apparmor_parser -r -W /etc/apparmor.d/profile_created_by_genprof
sudo aa-enforce /etc/apparmor.d/profile_created_by_genprof
