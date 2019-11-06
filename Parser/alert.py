#!/usr/bin/env python2
import io
import sys
from collections import OrderedDict

alert_logs = []

#namespace
alert = str(sys.argv[1])
alert_msg = str(sys.argv[2])

with open(alert,'r') as infile:
	data = infile.readlines()
	x=0
	for i in xrange(len(data)): #because we will need the next line
                alert_logs.append("Container " + data[i].strip('\n') + " " + alert_msg + "\n")

#Output
with open('alert_logs', 'w') as outfile:
	outfile.writelines( alert_logs )
