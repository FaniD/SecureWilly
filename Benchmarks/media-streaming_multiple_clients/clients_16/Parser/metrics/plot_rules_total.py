#!/usr/bin/env python

import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.collections import LineCollection
from matplotlib.colors import colorConverter

service_list = ["dataset","server","client1", "client2", "client3", "client4", "client5", "client6", "client7", "client8", "client9", "client10", "client11", "client12", "client13", "client14", "client15", "client16"]
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
ax.plot(x_Axis, rules[1], label="server", color="red", marker='o')
ax.plot(x_Axis, rules[2], label="client1", color="blue", marker='o')
ax.plot(x_Axis, rules[3], label="client2", color="magenta", marker='o')
ax.plot(x_Axis, rules[4], label="client3", color="y", marker='o')
ax.plot(x_Axis, rules[5], label="client4", color=(0.3,0.1,0.4,0.6), marker='o')
ax.plot(x_Axis, rules[6], label="client5", color="gray", marker='o')
ax.plot(x_Axis, rules[7], label="client6", color="peru", marker='o')
ax.plot(x_Axis, rules[8], label="client7", color="tomato", marker='o')
ax.plot(x_Axis, rules[9], label="client8", color="olive", marker='o')

ax.plot(x_Axis, rules[10], label="client9", color="teal", marker='o')
ax.plot(x_Axis, rules[11], label="client10", color="brown", marker='o')
ax.plot(x_Axis, rules[12], label="client11", color="hotpink", marker='o')
ax.plot(x_Axis, rules[13], label="client12", color="rosybrown", marker='o')
ax.plot(x_Axis, rules[14], label="client13", color="darkorange", marker='o')
ax.plot(x_Axis, rules[15], label="client14", color="sienna", marker='o')
ax.plot(x_Axis, rules[16], label="client15", color="maroon", marker='o')
ax.plot(x_Axis, rules[17], label="client16", color="indigo", marker='o')

box = ax.get_position()
ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])

ax.legend(loc='center left', bbox_to_anchor=(1, 0.5), fancybox=True, shadow=True)
#ax.legend(loc=0)
ax.grid()
ax.set_xlabel("Runs")
ax.set_ylabel(r"Rules")
ax.set_ylim(0,max_value+2)
plt.show()
plt.title("Rules per run")
plt.savefig("../../parser_output/rules.png",bbox_inches="tight")


