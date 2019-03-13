#!/usr/bin/env python
import io
import sys
from collections import OrderedDict

run_time = []

#mini yml file
time_of_runs = str(sys.argv[1])

with open(time_of_runs,'r') as infile:
        data = infile.readlines()

        x=0
	for i in xrange(len(data)): #because we will need the next line
		if 'user' in data[i]:
			z = i
                        #usr_time = data[z].rstrip('\n')
                        usr_time = data[z].split('\t')
                        usr = usr_time[1]
                        usr = usr.rstrip('\n')
                        usr = usr.rstrip('s')
                        usr_l = usr.split('m')
                        usr = usr_l[1]
                        #sys_time = data[z+1].rstrip('\n')
                        sys_time = data[z+1].split('\t')
                        sys = sys_time[1]
                        sys = sys.rstrip('\n')
                        sys = sys.rstrip('s')
                        sys_l = sys.split('m')
                        sys = sys_l[1]
                        time_ = float(usr) + float(sys)
                        run_time.append(str(time_) + '\n')
#Output
with open('time_total', 'w') as outfile:
	outfile.writelines( run_time )

