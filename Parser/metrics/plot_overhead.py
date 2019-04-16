#!/usr/bin/env python

import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

# data to plot
n_groups = 3 #sys, user, real
total_runs = (108,327,10603)
threshold = (83,352,10832)
  
# create plot
fig,ax = plt.subplots()
index = np.arange(n_groups)
bar_width = 0.35
#opacity = 0.8
   
rects1 = plt.bar(index, total_runs, bar_width, color = (0.3,0.1,0.4,0.6), label='Unconfined')
rects2 = plt.bar(index + bar_width, threshold, bar_width, color = (0.3,0.9,0.4,0.6), label='AppArmor profiles enforced')

plt.xlabel('Nextcloud time output')
plt.ylabel('sec')
plt.title('AppArmor Overhead')
plt.xticks(index + bar_width, ('sys time', 'user time', 'real time'))

box = ax.get_position()
ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])
ax.legend(loc='center left', bbox_to_anchor=(1, 0.5), fancybox=True, shadow=True)

plt.tight_layout()
plt.show()
plt.savefig("./overhead.png",bbox_inches="tight")
