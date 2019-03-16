#!/usr/bin/env python

import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

cap = sys.argv[1]
net = sys.argv[2]
sgn = sys.argv[3]
mnt = sys.argv[4]
rlim = sys.argv[5]
f_rules = sys.argv[6]
num_of_runs = sys.argv[7]
service = sys.argv[8]

num_of_runs = int(num_of_runs)

#Create int lists from string arrays
#Reading per line and appending list
capabilities = []
with open(cap,'r') as infile:
    data = infile.readlines()
    for line in data:
        line = line.strip('\n')
        line = int(line)
        capabilities.append(line)

network = []
with open(net,'r') as infile:
    data = infile.readlines()
    for line in data:
        line = line.strip('\n')
        line = int(line)
        network.append(line)

signal = []
with open(sgn,'r') as infile:
    data = infile.readlines()
    for line in data:
        line = line.strip('\n')
        line = int(line)
        signal.append(line)

mount = []
with open(mnt,'r') as infile:
    data = infile.readlines()
    for line in data:
        line = line.strip('\n')
        line = int(line)
        mount.append(line)

rlimit = []
with open(rlim,'r') as infile:
    data = infile.readlines()
    for line in data:
        line = line.strip('\n')
        line = int(line)
        rlimit.append(line)

file_rules = []
with open(f_rules,'r') as infile:
    data = infile.readlines()
    for line in data:
        line = line.strip('\n')
        line = int(line)
        file_rules.append(line)

#Sort all lists because versions may have not been in line and find max
#For sorting we don't use sort because it returns none, sorted instead returns the sorted list
#We need the max values of rules of all services for y axis limit
max_rules = []
capabilities = sorted(capabilities)
max_rules.append(max(capabilities))
network = sorted(network)
max_rules.append(max(network))
signal = sorted(signal)
max_rules.append(max(signal))
mount = sorted(mount)
max_rules.append(max(mount))
rlimit = sorted(rlimit)
max_rules.append(max(rlimit))
file_rules = sorted(file_rules)
max_rules.append(max(file_rules))
max_value = max(max_rules)

x_Axis=[]
for x in range(int(num_of_runs)):
    x_Axis.append(x)

fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(x_Axis, capabilities, label="capabilities", color="r", marker='o')
ax.plot(x_Axis, network, label="network", color="g", marker='o')
ax.plot(x_Axis, signal, label="signal", color="m", marker='o')
ax.plot(x_Axis, mount, label="mount", color="y", marker='o')
ax.plot(x_Axis, rlimit, label="rlimit", color="k", marker='o')
ax.plot(x_Axis, file_rules, label="file", color="b", marker='o')

#ax.legend(loc=0)
#ax.legend(loc='upper center', bbox_to_anchor=(0.5, 1.05),
#                  ncol=3, fancybox=True, shadow=True)

box = ax.get_position()
ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])

# Put a legend below current axis
ax.legend(loc='center left', bbox_to_anchor=(1, 0.8),
                  fancybox=True, shadow=True)

#ax.grid()

##1st plot
ax.set_xlabel("Runs")
ax.set_ylabel(r"Rules")
ax.set_ylim(0,max_value+2)
plt.show()
plt.title("Types of rules per run")
output = "../../parser_output/types_" + service + ".png"
plt.savefig(output,bbox_inches="tight")
###
fig = plt.figure()

##Bars

#index = np.arange(n_groups)
bar_width = 0.3

objects = ('Capabilities', 'Network', 'Signal', 'Mount', 'File', 'Rlimit')
y_pos = np.arange(len(objects))
 
barlist = []
barlist.append(capabilities[-1])
barlist.append(network[-1])
barlist.append(signal[-1])
barlist.append(mount[-1])
barlist.append(file_rules[-1])
barlist.append(rlimit[-1])

max_value=max(barlist)
plt.bar(y_pos, barlist, align='center', alpha=0.5)
plt.xticks(y_pos, objects)
ax.set_ylim(0,max_value+0.5)
plt.ylabel('Rules')
plt.title('Amount of each type of rule in final profile')
plt.show()

#box = ax.get_position()
#ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])

# Put a legend below current axis
#ax.legend(loc='center left', bbox_to_anchor=(1, 0.8),
#                          fancybox=True, shadow=True)

#plt.show()
output = "../../parser_output/Barfinal_" + service + ".png"
plt.savefig(output,bbox_inches="tight")

