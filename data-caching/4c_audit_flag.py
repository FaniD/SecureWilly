#!/usr/bin/env python
import io
import sys
from collections import OrderedDict

#This will be the output profile
new_profile = []

service = str(sys.argv[1])
version = str(sys.argv[2]) #New version
mode = 'complain'

new = 'profiles/' + service + '/version_' + str(round_)

old_profile = 'profiles/' + service + '/version_' + version
awk_caps = 'Logs/RUN' + version +'/awk_out/' + mode + '_logs_caps_' + service
awk_net = 'Logs/RUN' + version +'/awk_out/' + mode + '_logs_net_' + service
awk_file = 'Logs/RUN' + version +'/awk_out/' + mode + '_logs_file_' + service

with open(old_profile,'r') as infile:
    data = infile.readlines()

profile = 'profile'
#In my parser I user profile name not paths. If paths are used here I have to search for paths noo. Not fixed yet.
#path_to_profile = ''
include = '#include'
tunables = 'tunables/global'
closure = '}'
base = []

for line in data:
    if include in line:
        if not tunables in line:
            base.append(line)
    elif line.startswith(profile):
        base.append('#include <tunables/global>\n\n')
        line = line.strip('\n')
        base.append(line)

        #Base is ready
        #Add all the rules from here on
        #Except for the closure '}'

    elif '}' in line:
        break
    else:
        new_profile.append(line) 

#new_profile.insert(0, '#include <tunables/global>\n\nprofile new_profile flags=(attach_disconnected,mediate_deleted) {\n\n')

#Output
with open(new, 'w') as outfile:
	outfile.writelines( new_profile )

