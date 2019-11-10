#!/usr/bin/env python2

import io
import sys
from collections import OrderedDict

# This will be the output profile
new_profile = []

service = str(sys.argv[1])
path = '../parser_output/profiles/' + service + '/version_1'

with open(path,'r') as infile:
  data = infile.readlines()

# If network rule is encountered do nothing, anything else must be included in new profile
for line in data:
  if not 'network' in line:
    new_profile.append(line)

# Output
with open(path, 'w') as outfile:
  outfile.writelines( new_profile )
