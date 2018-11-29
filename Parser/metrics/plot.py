#!/usr/bin/env python

import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

service_list = ["dataset","server","client"]
services = len(service_list)
num_of_runs = sys.argv[services+1]

rules=[[None for _ in range(int(num_of_runs))] for _ in range(services)]

rules_services=[]
i=1
for SERVICE in service_list:
    rules_services.append(str(sys.argv[i]))
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
#    rules[i]=[]
    with open(rules_services[i],'r') as infile:
        data = infile.readlines()
    for line in data:
        line = line.strip('\n')
        rules[i].append(line)
    i+=1

"""
#Do for every service
#Service 1
with open(rules_dataset,'r') as infile:
    data = infile.readlines()

dataset=[]
for line in data:
    line = line.strip('\n')
    dataset.append(line)

#Service 2
with open(rules_client,'r') as infile:
    data = infile.readlines()
client=[]
for line in data:
    line = line.strip('\n')
    client.append(line)

#Service 3
with open(rules_server,'r') as infile:
    data = infile.readlines()
server=[]
for line in data:
    line = line.strip('\n')
    server.append(line)
"""

max_rules = []
for i in range(services):
    max_rules.append(rules[i][int(num_of_runs)-1])
max_value = max(max_rules)

"""
x_Axis=[]
for x in range(int(num_of_runs)):
    x_Axis.append(x)
"""   

#Non generic part
fig, ax1 = plt.subplots()
#axAx = np.arange(len(x_Axis))
#ax1.xaxis.set_ticks(np.arange(0, len(x_Axis), 1))
ax1.grid(True)
ax1.set_xlabel("Runs")
ax1.set_ylabel("Rules")
ax1.axis([0, int(num_of_runs), 0, max_value])
#ax1.set_xlim(-0.5, len(x_Axis) - 0.5)
#ax1.set_ylim(min(rules[0]) - 0.005, max(rules[3]) + 0.005)
line1 = ax1.plot(rules[0], label="dataset", color="green", marker='x')

ax2 = ax1.twinx()
#ax2.set_xlabel("Runs")
#ax2.set_ylabel("Rules")
line2 = ax2.plot(rules[1], label="client", color="red", marker='o')

ax3 = ax1.twinx()
#ax3.set_xlabel("Runs")
#ax3.set_ylabel("Rules")
line3 = ax3.plot(rules[2], label="server", color="blue", marker='x')

lns = line1 + line2 + line3
labs = [l.get_label() for l in lns]

#plt.plot(rules_dataset, 'r--', rules_client, 'bs', rules_server, 'g^')
#plt.show()

plt.title("Rules per run")
lgd = plt.legend(lns, labs)
lgd.draw_frame(False)
plt.savefig("rules.png",bbox_inches="tight")


"""
xAx = np.arange(len(x_Axis))
ax1.xaxis.set_ticks(np.arange(0, len(x_Axis), 1))
ax1.set_xticklabels(x_Axis, rotation=45)
ax1.set_xlim(-0.5, len(x_Axis) - 0.5)
ax1.set_ylim(min(ipc_Axis) - 0.005, max(ipc_Axis) + 0.005)
ax1.set_ylabel("$Rules Increase$")
line1 = ax1.plot(ipc_Axis, label="rules", color="blue",marker='x')
"""
