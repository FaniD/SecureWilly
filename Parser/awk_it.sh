#!/bin/bash

for SERVICE in server client dataset; do
#for N in 1 ... ${SERVICES} ; do
	awk '/capability/ {print $16;}' ../media-streaming/audit_messages/complain_messages/kernlogs_${SERVICE} > caps/caps1
	awk 'BEGIN {FS="=";} {gsub(/"/,"",$2); print $2;}' caps/caps1 > caps/caps1_${SERVICE}
	rm caps/caps1

	awk '/capability/ {print $11;}' ../media-streaming/audit_messages/complain_messages/dmesg_${SERVICE} > caps/caps2
	awk 'BEGIN {FS="=";} {gsub(/"/,"",$2); print $2;}' caps/caps2 > caps/caps2_${SERVICE}
	rm caps/caps2
done
