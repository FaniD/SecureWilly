#!/usr/bin/env python
import io
import sys
from collections import OrderedDict

#This will be the output profile
new_profile = []

service = str(sys.argv[1])
path = 'profiles/' + service + '/version_1'

with open(old_profile,'r') as infile:
    data = infile.readlines()

#If network rule is encountered do nothing, anything else must be included in new profile
for line in data:
    if not network in line:
        new_profile.append(line)

#Output
with open(path, 'w') as outfile:
	outfile.writelines( new_profile )
