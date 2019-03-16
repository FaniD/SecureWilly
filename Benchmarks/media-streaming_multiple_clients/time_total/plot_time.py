#!/usr/bin/env python

import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

time1 = sys.argv[1]
time4 = sys.argv[2]
time8 = sys.argv[3]
#time16 = sys.argv[4]

#Create int lists from string arrays
#Reading per line and appending list
sec = [0]
with open(time1,'r') as infile:
    data = infile.readlines()
    for line in data:
        line = line.strip('\n')
        line = int(line)
        sec.append(line)


sec1 = [0]
with open(time4,'r') as infile:
    data = infile.readlines()
    for line in data:
        line = line.strip('\n')
        line = int(line)
        sec1.append(line)

sec2 = [0]
with open(time8,'r') as infile:
    data = infile.readlines()
    for line in data:
        line = line.strip('\n')
        line = int(line)
        sec2.append(line)


#sec3=[0]
#with open(time16,'r') as infile:
#    data = infile.readlines()
#    for line in data:
#        line = line.strip('\n')
#        line = int(line)
#        sec3.append(line)




x_Axis = np.arange(len(sec))

fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(x_Axis, sec, label="1 client", color="darkcyan", marker='o')
ax.plot(x_Axis, sec1, label="4 clients", color="mediumvioletred", marker='o')
ax.plot(x_Axis, sec2, label="8 clients", color="crimson", marker='o')
#ax.plot(x_Axis, sec3, label="16 clients", color="forestgreen", marker='o')

box = ax.get_position()
ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])
ax.legend(loc='center left', bbox_to_anchor=(1, 0.5), fancybox=True, shadow=True)

##1st plot
ax.set_xlabel("Runs")
ax.set_ylabel(r"Time(sec)")
#ax.set_ylim(0,max_value+2)
plt.show()
plt.title("Time of test plan per run")
output = "./time.png"
plt.savefig(output,bbox_inches="tight")
