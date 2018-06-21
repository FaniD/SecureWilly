#!/usr/bin/env python
import io
import sys
from collections import OrderedDict

#This will be the output profile
new_profile = []

service = str(sys.argv[1])
version = str(sys.argv[2]) #Old version! The one that exists! (~number here~)
mode = str(sys.argv[3]) #complain, enforce, complain_audit, enforce_audit

round_ = int(version)+1
new = 'profiles/' + service + '/version_' + str(round_)

old_profile = 'profiles/' + service + '/version_' + version
awk_caps = 'Logs/RUN' + version +'/awk_out/' + mode + '_logs_caps_' + service
awk_net = 'Logs/RUN' + version +'/awk_out/' + mode + '_logs_net_' + service
awk_file = 'Logs/RUN' + version +'/awk_out/' + mode + '_logs_file_' + service

with open(old_profile,'r') as infile:
    data = infile.readlines()

#This rule is needed so that we can work with files (create files/directories, copy, etc)
file_rule = '\tfile,  #This rule is needed so that I can work with files (create files/directories, copy, etc)\n'

#Search for chmod or chown in Dockerfile
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
        base.append(line)

        #Base is ready
        #Add all the rules from here on
        #Except for the closure '}'

    elif '}' in line:
        break
    else:
        new_profile.append(line) 


#Now create rules from awk logs

#Capability rules
with open(awk_caps,'r') as infile:
    data = infile.readlines()

for line in data:
    line = line.strip('\n')
    new_profile.append('\tcapability ' + line + ',\n')

#Network rules
with open(awk_net,'r') as infile:
    data = infile.readlines()

for line in data:
    line = line.strip('\n')
    new_profile.append('\tnetwork ' + line + ',\n')

#File rules
with open(awk_caps,'r') as infile:
    data = infile.readlines()

for line in data:
    line = line.strip('\n')
    line = line.split(' ')
    permission = line[1]
    if line[1] == 'c': #There is no create permission in apparmor so we change it to write
        permission = 'w'
    if line[1] == 'x': #x must follow i,p,c,u so if there is none of these with x we give i permission
        permission = 'ix'
    new_profile.append('\t' + line[0] + ' ' + permission + ',\n')


#Delete duplicate rules by converting list to set. Convert back to list to keep the order of the beggining and ending of a profile
#This is the way to delete duplicates, when we don't care about the order
new_profile = list(set(new_profile))

#Add the base of the profile in the beginning
#new_profile.insert(0, '#include <tunables/global>\n\nprofile new_profile flags=(attach_disconnected,mediate_deleted) {\n\n')
new_profile = base + new_profile
#i = 0
#for line in base:
 #   new_profile.insert(i, line)
  #  i=i+1

#End of logs so close the bracket
new_profile.append('}\n')


#Output
with open(new, 'w') as outfile:
	outfile.writelines( new_profile )

