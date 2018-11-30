#!/usr/bin/env python

import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

service_list = ["dataset","server","client"]
services = len(service_list)
num_of_runs = sys.argv[services+1]

rules=[] #This will be a 2d list, with services as rows and columns as totals of the rules of the services
rules_services=[]
i=1
for SERVICE in service_list:
    rules_services.append(str(sys.argv[i]))
    rules.append([]) #initiate list of each row
    i+=1

#rules_dataset = str(sys.argv[1])
#rules_client = str(sys.argv[2])
#rules_server = str(sys.argv[3])

#Fix this argv as needed
num_of_runs = str(sys.argv[4])

#Create int lists from string arrays
i=0
#rules=[]
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

x_Axis=[]
for x in range(int(num_of_runs)):
    x_Axis.append(x)

fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(x_Axis, rules[0], label="dataset", linewidth=0.3, color="green", marker='x')
ax.plot(x_Axis, rules[1], label="client", color="red", marker='x')
ax.plot(x_Axis, rules[2], label="server", color="blue", marker='x')
"""
leg_lines = plt.get_lines()
leg_texts = plt.get_texts()
# bulk-set the properties of all lines and texts
plt.setp(leg_lines, linewidth=4)
"""
ax.legend(loc=0)
ax.grid()
ax.set_xlabel("Runs")
ax.set_ylabel(r"Rules")
ax.set_ylim(0,max_value+2)
plt.show()
plt.title("Rules per run")
plt.savefig("rules.png",bbox_inches="tight")
