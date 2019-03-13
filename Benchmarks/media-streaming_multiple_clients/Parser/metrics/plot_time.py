#!/usr/bin/env python

import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

time = sys.argv[1]

#Create int lists from string arrays
#Reading per line and appending list
sec = [0]
with open(time,'r') as infile:
    data = infile.readlines()
    for line in data:
        line = line.strip('\n')
        line = int(line)
        sec.append(line)


x_Axis = np.arange(len(sec))

fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(x_Axis, sec, label="time", color="b", marker='o')

##1st plot
ax.set_xlabel("Runs")
ax.set_ylabel(r"Time(sec)")
#ax.set_ylim(0,max_value+2)
plt.show()
plt.title("Time of test plan per run")
output = "../../parser_output/plots/time.png"
plt.savefig(output,bbox_inches="tight")
