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

x_Axis = range(int(num_of_runs))

fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(x_Axis, rules[0], label="dataset", color="green", marker='o')
ax.plot(x_Axis, rules[1], label="client", color="red", marker='o')
ax.plot(x_Axis, rules[2], label="server", color="blue", marker='o')

box = ax.get_position()
ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])

ax.legend(loc='center left', bbox_to_anchor=(1, 0.5), fancybox=True, shadow=True)
#ax.legend(loc=0)
#ax.grid()
ax.set_xlabel("Runs")
ax.set_ylabel(r"Rules")
ax.set_ylim(0,max_value+2)
plt.show()
plt.title("Rules per run")
plt.savefig("../../parser_output/rules.png",bbox_inches="tight")

#Complain and enforce different colour
complain_enforce = []
with open("changes",'r') as infile:
    data = infile.readlines()
    for line in data:
        line = line.strip('\n')
        line = int(line)
        complain_enforce.append(line)

fig = plt.figure()
part_1a = []
part_1b = []
part_1c = []
part_2a = []
part_2b = []
part_2c = []
#part_3a = []
#part_3b = []
#part_3c = []
#part_4a = []
#part_4b = []
#part_4c = []

compl_rules = range(complain_enforce[0]+1)
enf_rules = range(complain_enforce[0],int(num_of_runs)) #complain_enforce[1]+1)
#compl_audit = range(complain_enforce[1],complain_enforce[2]+1)
#enf_audit = range(complain_enforce[2],int(num_of_runs))

for x1 in range(complain_enforce[0]+1):
    part_1a.append(rules[0][x1])
    part_1b.append(rules[1][x1])
    part_1c.append(rules[2][x1])
for x1 in range(complain_enforce[0], int(num_of_runs)): #complain_enforce[1]+1):
    part_2a.append(rules[0][x1])
    part_2b.append(rules[1][x1])
    part_2c.append(rules[2][x1])
#for x1 in range(complain_enforce[1], complain_enforce[2]+1):
#    part_3a.append(rules[0][x1])
#    part_3b.append(rules[1][x1])
#    part_3c.append(rules[2][x1])
#for x1 in range(complain_enforce[2], int(num_of_runs)):
#    part_4a.append(rules[0][x1])
#    part_4b.append(rules[1][x1])
#    part_4c.append(rules[2][x1])

ax1 = fig.add_subplot(311)
ax1.plot(compl_rules, part_1a, label="complain mode", color="blue", marker='o') 
ax1.plot(enf_rules, part_2a, label="enforce mode", color="red", marker='o')
#ax1.plot(compl_audit, part_3a, label="complain audit", color="green", marker='x')
#ax1.plot(enf_audit, part_4a, label="enforce audit", color="darkmagenta", marker='x')

ax2 = fig.add_subplot(312)
ax2.plot(compl_rules, part_1b, label="complain mode", color="blue", marker='o')
ax2.plot(enf_rules, part_2b, label="enforce mode", color="red", marker='o')
#ax2.plot(compl_audit, part_3b, label="complain audit", color="green", marker='x')
#ax2.plot(enf_audit, part_4b, label="enforce audit", color="darkmagenta", marker='x')

ax3 = fig.add_subplot(313)
ax3.plot(compl_rules, part_1c, label="complain mode", color="blue", marker='o')
ax3.plot(enf_rules, part_2c, label="enforce mode", color="red", marker='o')
#ax3.plot(compl_audit, part_3c, label="complain audit", color="green", marker='x')
#ax3.plot(enf_audit, part_4c, label="enforce audit", color="darkmagenta", marker='x')


box = ax1.get_position()
#ax1.set_position([box.x0, box.y0*1.02, box.width, box.height*0.2])

ax1.legend(loc='lower left', bbox_to_anchor=(0,1.02,1, 0.2), ncol=2, fancybox=True, shadow=True, mode="expand")


#ax1.legend(loc=1,prop={'size': 12})
#ax1.grid()
#ax2.grid()
#ax3.grid()
ax3.set_xlabel("Runs")
ax1.set_ylabel(r"Dataset rules")
ax2.set_ylabel(r"Server rules")
ax3.set_ylabel(r"Client rules")
ax1.set_ylim(0,max_value+2)
ax2.set_ylim(0,max_value+2)
ax3.set_ylim(0,max_value+2)
plt.show()
#plt.title("Rules per run")
plt.savefig("../../parser_output/complain_enforce_rules.png",bbox_inches="tight")

