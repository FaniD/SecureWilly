#!/usr/bin/env python
import io
import sys
from collections import OrderedDict

if_vol = []
#service_volumes = []

#mini yml file
yml = str(sys.argv[1])

with open(yml,'r') as infile:
	data = infile.readlines()

	mount = 'volumes:'
	x=0
	for i in xrange(len(data)): #because we will need the next line
		if mount in data[i]:
			z = i
                        if_vol.append("( line.startswith('")
			while ('-' in data[z+1]):
				src_mntpnt = data[z+1].strip()
				src_mntpnt = src_mntpnt.strip('"')
				src_mntpnt = src_mntpnt.split(':')
				src = src_mntpnt[0].strip('-')
				src = src.strip()
				src = src.strip('"')
				mntpnt = src_mntpnt[1]

                                if (mntpnt.endswith('/')):
                                    mntpnt = mntpnt.rstrip('/')
                              
               #                 service_volumes.append(mntpnt + '\n')
                                
                                if (x>0):
                                    if_vol.append("or linestartswith('")
                                if_vol.append(mntpnt + "') ")
				z = z+1
			        x = x+1
              #  service_volumes.append(x + '\n')
                if_vol.append("): continue")
        if_vol.append("%" + str(x))
#Output
with open('if_vol', 'w') as outfile:
	outfile.writelines( if_vol )

