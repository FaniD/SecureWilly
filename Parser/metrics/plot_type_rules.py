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
ax.plot(x_Axis, capabilities, label="capabilities", color="r", marker='x')
ax.plot(x_Axis, network, label="network", color="g", marker='x')
ax.plot(x_Axis, signal, label="signal", color="m", marker='x')
ax.plot(x_Axis, mount, label="mount", color="k", marker='x')
ax.plot(x_Axis, rlimit, label="rlimit", color="y", marker='x')
ax.plot(x_Axis, file_rules, label="file", color="b", marker='x')

ax.legend(loc=0)
ax.grid()
ax.set_xlabel("Runs")
ax.set_ylabel(r"Rules")
ax.set_ylim(0,max_value+2)
plt.show()
plt.title("Type of rules per run")
output = "../../parser_output/types_" + service + ".png"
plt.savefig(output,bbox_inches="tight")

enforce = 5 #Read this from bash script 

fig = plt.figure()
compl_rules = range(enforce+1)
enf_rules = range(enforce,int(num_of_runs))

#File rules
ax1 = fig.add_subplot(321)
part_1a = []
part_2a = []
for x1 in range(enforce+1):
	part_1a.append(file_rules[x1])
for x1 in range(enforce,int(num_of_runs)):
	part_2a.append(file_rules[x1])
ax1.plot(compl_rules, part_1a, label="file", color="b", marker='x')
ax1.plot(enf_rules, part_2a, label="file", color="r", marker='x')
ax1.grid()
ax1.set_xlabel("Runs")
ax1.set_ylabel(r"File rules")
ax1.set_ylim(0,max_value+2)

#Capabilities
ax1 = fig.add_subplot(322)
part_1b = []
part_2b = []
for x1 in range(enforce+1):
        part_1b.append(capabilities[x1])
for x1 in range(enforce,int(num_of_runs)):
        part_2a.append(capabilities[x1])
ax1.plot(compl_rules, part_1b, label="", color="b", marker='x')
ax1.plot(enf_rules, part_2b, label="", color="r", marker='x')
ax1.grid()
ax1.set_xlabel("Runs")
ax1.set_ylabel(r" rules")
ax1.set_ylim(0,max_value+2)


#Network
ax2 = fig.add_subplot(323)                                             
part_1b = []
part_2b = []
for x1 in range(enforce+1):                                            
        part_1b.append(capabilities[x1])                               
for x1 in range(enforce,int(num_of_runs)):                             
        part_2a.append(capabilities[x1])                               
ax2.plot(compl_rules, part_1b, label="network", color="b", marker='x')
ax2.plot(enf_rules, part_2b, label="network", color="r", marker='x')
ax2.grid()                                                             
ax2.set_xlabel("Runs")
ax2.set_ylabel(r"Network rules")
ax2.set_ylim(0,max_value+2)

#Mount
ax3 = fig.add_subplot(324)                                             
part_1c = []
part_2c = []
for x1 in range(enforce+1):                                            
        part_1b.append(mount[x1])                               
for x1 in range(enforce,int(num_of_runs)):                             
        part_2a.append(mount[x1])                               
ax3.plot(compl_rules, part_1c, label="mount", color="b", marker='x')
ax3.plot(enf_rules, part_2c, label="mount", color="r", marker='x')
ax3.grid()                                                             
ax3.set_xlabel("Runs")
ax3.set_ylabel(r"Mount rules")
ax3.set_ylim(0,max_value+2)

#Signal
ax4 = fig.add_subplot(325)                                             
part_1d = []
part_2d = []
for x1 in range(enforce+1):                                            
        part_1b.append(signal[x1])                               
for x1 in range(enforce,int(num_of_runs)):                             
        part_2a.append(signal[x1])                               
ax4.plot(compl_rules, part_1d, label="signal", color="b", marker='x')
ax4.plot(enf_rules, part_2d, label="signal", color="r", marker='x')
ax4.grid()                                                             
ax4.set_xlabel("Runs")
ax4.set_ylabel(r"Signal rules")
ax4.set_ylim(0,max_value+2)

#Rlimit
ax5 = fig.add_subplot(326)                                             
part_1e = []
part_2e = []
for x1 in range(enforce+1):                                            
        part_1e.append(rlimit[x1])                               
for x1 in range(enforce,int(num_of_runs)):                             
        part_2e.append(rlimit[x1])                               
ax5.plot(compl_rules, part_1e, label="rlimit", color="b", marker='x')
ax5.plot(enf_rules, part_2e, label="rlimit", color="r", marker='x')
ax5.grid()                                                             
ax5.set_xlabel("Runs")
ax5.set_ylabel(r"Rlimit rules")
ax5.set_ylim(0,max_value+2)


plt.show()
output = "../../parser_output/complain_enforce_types_" + service + ".png"
plt.savefig(output,bbox_inches="tight")
