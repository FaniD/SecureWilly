#!/bin/sh
sudo cp prof_by_no_audit_logs /etc/apparmor.d/
sudo apparmor_parser -r -W /etc/apparmor.d/prof_by_no_audit_logs
sudo aa-enforce /etc/apparmor.d/prof_by_no_audit_logs
