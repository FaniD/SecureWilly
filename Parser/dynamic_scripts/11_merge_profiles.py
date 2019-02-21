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
new_path = '../parser_output/profiles/' + service + '/version_' + str(round_)

old_profile = '../parser_output/profiles/' + service + '/version_' + version
awk_caps = '../parser_output/Logs/RUN' + version +'/awk_out/' + mode + '_logs_caps_' + service
awk_net = '../parser_output/Logs/RUN' + version +'/awk_out/' + mode + '_logs_net_' + service
awk_file = '../parser_output/Logs/RUN' + version +'/awk_out/' + mode + '_logs_file_' + service
awk_sgn = '../parser_output/Logs/RUN' + version +'/awk_out/' + mode + '_logs_sgn_' + service

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
#        line = line.strip('\n')
        base.append(line)

        #Base is ready
        #Add all the rules from here on
        #Except for the closure '}'

    elif '}' in line:
        break
    else:
        line = line.strip('\n')
        new_profile.append(line + '\n') 


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
with open(awk_file,'r') as infile:
    data = infile.readlines()

for line in data:
    if 'requested_mask' in line: #If this is in logs then there is no rule for a certain operation so we omit it
        continue

    #~~~Test /var/lib/docker
    if '/var/lib/docker/' in line:
        continue
    #~~~

    line = line.strip('\n')
    line = line.split(' ')
    permission = line[1]
    if 'c' in line[1]: #There is no create permission in apparmor so we change it to write
        if 'w' in line[1]: #if permission is wc we omit c
            permission = line[1].replace("c","")
        else:
            permission = line[1].replace("c","w") #if permission is just c we change it to w
    if 'd' in line[1]: #There is no delete permission in apparmor so we change it to write
        if 'w' in line[1]: #if permission is wc we omit c
            permission = line[1].replace("d","")
        else:
            permission = line[1].replace("d","w") #if permission is just c we change it to w
    if line[1] == 'x': #x must follow i,p,c,u so if there is none of these with x we give i permission
        permission = 'ix'
    new_profile.append('\t' + line[0] + ' ' + permission + ',\n')

#Signal rules
with open(awk_sgn,'r') as infile:
    data = infile.readlines()

for line in data:
    line = line.strip('\n')
    line = line.split(' ') #Separate in requested_mask, set, peer
    new_profile.append('\tsignal (' + line[0] + ') set=(' + line[1] + ') peer=' + line[2] + ',\n')


#Delete duplicate rules by converting list to set. Convert back to list to keep the order of the beggining and ending of a profile
#This is the way to delete duplicates, when we don't care about the order
new_profile = list(set(new_profile))

#Now there might be some empty lines because of the duplicates missing
#Get rid of them
no_gaps = []
for line in new_profile:
    #Strip whitespace, should leave nothing if empty line was just "\n"
    if 'requested_mask' in line: #If this is in logs then there is no rule for a certain operation so we omit it
        continue
    if not line.strip():
        continue
    #We got something, save it
    else:
        no_gaps.append(line)

#Add the base of the profile in the beginning
#new_profile.insert(0, '#include <tunables/global>\n\nprofile new_profile flags=(attach_disconnected,mediate_deleted) {\n\n')
new_profile = base + no_gaps

#End of logs so close the bracket
new_profile.append('}\n')

#Output
with open(new_path, 'w') as outfile:
	outfile.writelines( new_profile )
