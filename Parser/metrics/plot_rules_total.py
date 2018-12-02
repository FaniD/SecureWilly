#!/usr/bin/env python

import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.collections import LineCollection
from matplotlib.colors import colorConverter

service_list = ["dataset","server","client"]
services = len(service_list)
num_of_runs = sys.argv[services+1]

rules=[] #This will be a 2d list, with services as rows and columns as totals of the rules of the services
rules_services=[]
i=1
for SERVICE in service_list:
    rules_services.append(str(sys.argv[i])) #reading paths of files with totals per run
    rules.append([]) #initiate list of each row
    i+=1

#Create int lists from string arrays
#Reading per line and appending list
i=0
for SERVICE in service_list:
    with open(rules_services[i],'r') as infile:
        data = infile.readlines()
    for line in data:
        line = line.strip('\n')
        line = int(line)
        rules[i].append(line)
    i+=1

#We need the max values of rules of all services for y axis limit
max_rules = []
for i in range(services):
    rules[i] = sorted(rules[i]) #We don't use sort because it returns none, sorted instead returns the sorted list
    max_rules.append(rules[i][int(num_of_runs)-1])
max_value = max(max_rules)

#x_Axis=[]
#for x in range(int(num_of_runs)):
#    x_Axis.append(x)
x_Axis = range(int(num_of_runs))

fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(x_Axis, rules[0], label="dataset", color="green", marker='x')
ax.plot(x_Axis, rules[1], label="client", color="red", marker='x')
ax.plot(x_Axis, rules[2], label="server", color="blue", marker='x')

ax.legend(loc=0)
ax.grid()
ax.set_xlabel("Runs")
ax.set_ylabel(r"Rules")
ax.set_ylim(0,max_value+2)
plt.show()
plt.title("Rules per run")
plt.savefig("../../parser_output/rules.png",bbox_inches="tight")

#Complain and enforce different colour

enforce = 5 #Read this from bash script

fig = plt.figure()
ax1 = fig.add_subplot(311)
part_1a = []
part_1b = []
part_1c = []
compl_rules = range(enforce+1)
part_2a = []
part_2b = []
part_2c = []
enf_rules = range(enforce,int(num_of_runs))

for x1 in range(enforce+1):
    part_1a.append(rules[0][x1])
    part_1b.append(rules[1][x1])
    part_1c.append(rules[2][x1])
for x1 in range(enforce,int(num_of_runs)):
    part_2a.append(rules[0][x1])
    part_2b.append(rules[1][x1])
    part_2c.append(rules[2][x1])

ax1.plot(compl_rules, part_1a, label="dataset", color="blue", marker='x') 
ax1.plot(enf_rules, part_2a, label="dataset", color="red", marker='x')

ax2 = fig.add_subplot(312)
ax2.plot(compl_rules, part_1b, label="server", color="blue", marker='x')
ax2.plot(enf_rules, part_2b, label="server", color="red", marker='x')

ax3 = fig.add_subplot(313)
ax3.plot(compl_rules, part_1c, label="client", color="blue", marker='x')
ax3.plot(enf_rules, part_2c, label="client", color="red", marker='x')

ax1.grid()
ax3.set_xlabel("Runs")
ax1.set_ylabel(r"Rules")
ax2.set_ylabel(r"Rules")
ax3.set_ylabel(r"Rules")
ax1.set_ylim(0,max_value+2)
ax2.set_ylim(0,max_value+2)
ax3.set_ylim(0,max_value+2)
plt.show()
#plt.title("Rules per run")
plt.savefig("../../parser_output/complain_enforce_rules.png",bbox_inches="tight")

