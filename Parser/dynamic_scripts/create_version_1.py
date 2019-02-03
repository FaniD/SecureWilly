#!/usr/bin/env python
import io
import sys
from collections import OrderedDict

#This will be the output profile
service = str(sys.argv[1])
new_path = '../parser_output/profiles/' + service + '/version_1'

#In my parser I user profile name not paths. If paths are used here I have to search for paths noo. Not fixed yet.
base = []
base.append('#include <tunables/global>\n\n')
base.append('profile ' + service + '_profile flags=(attach_disconnected,mediate_deleted) {\n')
base.append('\tfile,  #This rule is needed so that I can work with files (create files/directories, copy, etc)\n')
base.append('\t/var/lib/docker/* r,\n}\n')
base.append('\tdeny ptrace (readby, tracedby),\n')

#Output
with open(new_path, 'w') as outfile:
	outfile.writelines( base )

