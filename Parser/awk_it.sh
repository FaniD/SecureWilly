#!/bin/bash

LOGS="dmesg kernlogs"
#SERVICE="server client dataset"

for N in 1 ... ${SERVICES} ; do
	awk '/capability/ {print $16;}' kernlogs_${SERVICE} > caps
	awk 'BEGIN {FS="=";} {gsub(/"/,"",$2); print $2;}' caps

	awk '/capability/ {print $11;}' dmesg_${SERVICE} > caps
	awk 'BEGIN {FS="=";} {gsub(/"/,"",$2); print $2;}' caps
