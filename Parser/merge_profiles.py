#!/usr/bin/env python
import io
import sys
from collections import OrderedDict

#This will be the output profile
new_profile = []

print 'Give name of service, version and mode\n'
service = str(sys.argv[1])
version = str(sys.argv[2]) #New version
mode = str(sys.argv[3])

round_ = int(version)-1
old_profile = 'profiles/' + service + '/version_' + str(round_)
awk_logs = 'Logs/RUN' + version +'/awk_out/

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
        if line.startswith(profile):
                base.append('#include <tunables/global>\n\n')
                base.append(line)
                base.append(file_rule)

        #Base is ready
        #Add all the rules from here on
        #Except for the closure '}'

        if not closure in line:
               new_profile.append(line) 

#Now create rules from awk logs
with open(awk_logs,'r') as infile:
            data = infile.readlines()


capability = #Capability
network = #Network
file_ = #File

            cap = 'capability' + data[i]
            new_profile.append(cap)
        if network in data[i]:
            net = 'network' + data[i]
        if file_ in data[i]:
            file_r = 
#Delete duplicate rules by converting list to set. Convert back to list to keep the order of the beggining and ending of a profile
#This is the way to delete duplicates, when we don't care about the order
new_profile = list(set(new_profile))

#Delete duplicates, but keeping the order JUST FOR THE PRESENTATION in order to show the extracted rules from the correct orders
#static_profile = ordered_set(static_profile)

#Add the beggining and ending of the profile - do it in both inordered and not inoerdered lists
#beggining
static_profile.insert(0, '#include <tunables/global>\n\nprofile new_profile flags=(attach_disconnected,mediate_deleted) {\n\n')
#ending
static_profile.append('}\n')


#Output
with open('static_profile', 'w') as outfile:
	outfile.writelines( static_profile )

