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


#Complain and enforce different colour                                 
complain_enforce = []
with open("changes",'r') as infile:
    data = infile.readlines()
    for line in data:
        line = line.strip('\n')
        line = int(line)
        complain_enforce.append(line)

compl_rules = range(complain_enforce[0]+1)
enf_rules = range(complain_enforce[0],int(num_of_runs)) #complain_enforce[1]+1)
#compl_audit = range(complain_enforce[1],complain_enforce[2]+1)
#enf_audit = range(complain_enforce[2],int(num_of_runs))

part_1a = []
part_2a = []
#part_3a = []
#part_4a = []

part_1b = []
part_2b = []
#part_3b = []
#part_4b = []

part_1c = []
part_2c = []
#part_3c = []
#part_4c = []

part_1d = []
part_2d = []
#part_3d = []
#part_4d = []

part_1e = []
part_2e = []
#part_3e = []
#part_4e = []

part_1f = []
part_2f = []
#part_3f = []
#part_4f = []

for x1 in range(complain_enforce[0]+1):
    part_1a.append(file_rules[x1])
    part_1b.append(capabilities[x1])
    part_1c.append(network[x1])
    part_1d.append(mount[x1])
    part_1e.append(signal[x1])
    part_1f.append(rlimit[x1])

for x1 in range(complain_enforce[0], int(num_of_runs)): #complain_enforce[1]+1):
    part_2a.append(file_rules[x1])
    part_2b.append(capabilities[x1])
    part_2c.append(network[x1])     
    part_2d.append(mount[x1])  
    part_2e.append(signal[x1])
    part_2f.append(rlimit[x1])

#for x1 in range(complain_enforce[1], complain_enforce[2]+1):
#    part_3a.append(file_rules[x1])
#    part_3b.append(capabilities[x1])
#    part_3c.append(network[x1])            
#    part_3d.append(mount[x1])                    
#    part_3e.append(signal[x1])
#    part_3f.append(rlimit[x1])

#for x1 in range(complain_enforce[2], int(num_of_runs)):
#    part_4a.append(file_rules[x1])
#    part_4b.append(capabilities[x1])
#    part_4c.append(network[x1])            
#    part_4d.append(mount[x1])                    
#    part_4e.append(signal[x1])
#    part_4f.append(rlimit[x1])

#File rules
ax1 = fig.add_subplot(321)
ax1.plot(compl_rules, part_1a, label="complain mode", color="b", marker='o')
ax1.plot(enf_rules, part_2a, label="enforce mode", color="r", marker='o')
#ax1.plot(compl_audit, part_3a, label="file", color="g", marker='x')
#ax1.plot(enf_audit, part_4a, label="file", color="darkmagenta", marker='x')
#ax1.grid()
ax1.set_xlabel("Runs")
ax1.set_ylabel(r"File rules")
ax1.set_ylim(0,max_value+2)

#Capabilities
ax2 = fig.add_subplot(322)
ax2.plot(compl_rules, part_1b, label="capabilities", color="b", marker='o')
ax2.plot(enf_rules, part_2b, label="capabilities", color="r", marker='o')
#ax2.plot(compl_audit, part_3b, label="capabilities", color="g", marker='x')
#ax2.plot(enf_audit, part_4b, label="capabilities", color="darkmagenta", marker='x')
#ax2.grid()
ax2.set_xlabel("Runs")
ax2.set_ylabel(r"Capability rules")
ax2.set_ylim(0,max_value+2)

#Network
ax3 = fig.add_subplot(323)                                             
ax3.plot(compl_rules, part_1c, label="network", color="b", marker='o')
ax3.plot(enf_rules, part_2c, label="network", color="r", marker='o')
#ax3.plot(compl_audit, part_3c, label="network", color="g", marker='x')
#ax3.plot(enf_audit, part_4c, label="network", color="darkmagenta", marker='x')
#ax3.grid()                                                             
ax3.set_xlabel("Runs")
ax3.set_ylabel(r"Network rules")
ax3.set_ylim(0,max_value+2)

#Mount
ax4 = fig.add_subplot(324)                                             
ax4.plot(compl_rules, part_1d, label="mount", color="b", marker='o')
ax4.plot(enf_rules, part_2d, label="mount", color="r", marker='o')
#ax4.plot(compl_audit, part_3d, label="mount", color="g", marker='x')
#ax4.plot(enf_audit, part_4d, label="mount", color="darkmagenta", marker='x')
#ax4.grid()                                                             
ax4.set_xlabel("Runs")
ax4.set_ylabel(r"Mount rules")
ax4.set_ylim(0,max_value+2)

#Signal
ax5 = fig.add_subplot(325)                                             
ax5.plot(compl_rules, part_1e, label="signal", color="b", marker='o')
ax5.plot(enf_rules, part_2e, label="signal", color="r", marker='o')
#ax5.plot(compl_audit, part_3e, label="signal", color="g", marker='x')
#ax5.plot(enf_audit, part_4e, label="signal", color="darkmagenta", marker='x')
#ax5.grid()                                                             
ax5.set_xlabel("Runs")
ax5.set_ylabel(r"Signal rules")
ax5.set_ylim(0,max_value+2)

#Rlimit
ax6 = fig.add_subplot(326)                                             
ax6.plot(compl_rules, part_1f, label="rlimit", color="b", marker='o')
ax6.plot(enf_rules, part_2f, label="rlimit", color="r", marker='o')
#ax6.plot(compl_audit, part_3f, label="rlimit", color="g", marker='x')
#ax6.plot(enf_audit, part_4f, label="rlimit", color="darkmagenta", marker='x')
#ax6.grid()                                                             
ax6.set_xlabel("Runs")
ax6.set_ylabel(r"Rlimit rules")
ax6.set_ylim(0,max_value+2)

box = ax1.get_position()
ax1.legend(loc='lower left', bbox_to_anchor=(0,1.02,1, 0.2), ncol=2, fancybox=True, shadow=True, mode="expand")

#plt.show()
#output = "../../parser_output/ce_types_" + service + ".png"
#plt.savefig(output,bbox_inches="tight")
