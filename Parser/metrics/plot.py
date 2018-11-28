#!/usr/bin/env python

import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

#service_list=(dataset server client)

#i=1
#for SERVICE in "${service_list[@]}"; do
rules_dataset = str(sys.argv[1])
rules_client = str(sys.argv[2])
rules_server = str(sys.argv[3])

#i+=1
#done

#Fix this argv as needed
num_of_runs = str(sys.argv[4])

plt.plot(rules_dataset, 'r--', rules_client, 'bs', rules_server, 'g^')
plt.show()

"""
x_Axis = []
y_Axis = []

for line in sys.argv[1:]:


fig, ax1 = plt.subplots()
ax1.grid(True)
ax1.set_xlabel("$Runs$")

xAx = np.arange(len(x_Axis))
ax1.xaxis.set_ticks(np.arange(0, len(x_Axis), 1))
ax1.set_xticklabels(x_Axis, rotation=45)
ax1.set_xlim(-0.5, len(x_Axis) - 0.5)
ax1.set_ylim(min(ipc_Axis) - 0.005, max(ipc_Axis) + 0.005)
ax1.set_ylabel("$Rules Increase$")
line1 = ax1.plot(ipc_Axis, label="rules", color="blue",marker='x')
"""
