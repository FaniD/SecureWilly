#!/usr/bin/env python

import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

# data to plot
n_groups = 3 #Media streaming, Data caching, Nextcloud
total_runs = (6,6,7)
threshold = (3,3,4)
  
# create plot
fig,ax = plt.subplots()
index = np.arange(n_groups)
bar_width = 0.35
#opacity = 0.8
   
rects1 = plt.bar(index, total_runs, bar_width, color = (0.3,0.1,0.4,0.6), label='Total amount of runs')
rects2 = plt.bar(index + bar_width, threshold, bar_width, color = (0.3,0.9,0.4,0.6), label='Threshold')

plt.xlabel('Projects run by SecureWilly')
plt.ylabel('Runs')
plt.title('Totals runs and threshold for each project')
plt.xticks(index + bar_width, ('Media-streaming', 'Data-caching', 'Nextcloud'))

box = ax.get_position()
ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])
ax.legend(loc='center left', bbox_to_anchor=(1, 0.5), fancybox=True, shadow=True)

plt.tight_layout()
plt.show()
plt.savefig("./compare.png",bbox_inches="tight")
