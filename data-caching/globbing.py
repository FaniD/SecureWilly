#!/usr/bin/env python
import io
import sys
from collections import OrderedDict

service = str(sys.argv[1])
new_run = str(sys.argv[2]) #version! The one that exists! (~number here~)
mode_1 = str(sys.argv[3]) #complain, enforce, complain_audit, enforce_audit
mode_2 = str(sys.argv[4])

old_run = int(new_run)-1 #round

old_logs = 'Logs/RUN' + str(old_run) + '/awk_out/' + mode_1 + '_logs_file_' + service
new_logs = 'Logs/RUN' + str(new_run) + '/awk_out/' + mode_2 + '_logs_file_' + service

#Open old file logs and new file logs
with open(old_logs,'r') as infile:
    data_1 = infile.readlines()

with open(new_logs,'r') as infile:
    data_2 = infile.readlines()

new_rules = []
exact = 0

#Loop for old logs line by line and compare to new logs with every line
for line_f1 in data_1:
    for line_f2 in data_2:
        path_f1 = line_f1[0]
        permission_f1 = line_f1[1]
        path_f2 = line_f2[0]
        permission_f2 = line_f2[1]

        if path_f1 == path_f2:
            #Exact match. Delete line from file 2
            exact = exact + 1
        else:
            path_f1 = path_f1.split('/')
            path_f2 = path_f2.split('/')

            len_f1 = len(path_f1)
            len_f2 = len(path_f2)

            if len_f1 == len_f2 :
                if permission_f1 != permission_f2:
                    continue

                #So now maybe we are talking about the same path
                match = []
                i = 0
                num_of_zeros = 0

                for part_f1 in path_f1:
                    if part_f1 == path_f2[i]:
                        #Matching parts -> go to next one
                        match.append('1')
                    else:
                        match.append('0')
                        here_comes_the_instance = i
                        num_of_zeros = num_of_zeros + 1
                    i = i+1

                if num_of_zeros == 0:
                    #Exact match path... This was not supposed to happen
                    exact = exact + 1
                elif num_of_zeros == 1:
                    #Instance difference. Fix globbing syntax
                    new_rule=''
                    for i in range(0, here_comes_the_instance):
                        new_rule = new_rule + path_f1[i] + '/'
                    new_rule = new_rule + '*/'
                    for i in range(here_comes_the_instance+1, len(path_f1)-1):
                        new_rule = new_rule + path_f1[i] + '/'
                    new_rule = new_rule + path_f1[len(path_f1)]
                    #Add new rule to next profile... (?)
                    new_rules.append(new_rule)
                else:
                    #We are talking about different paths so go on
                    continue

            else:
                #Certainly different paths
                continue

#Output
with open('globbing_' + service, 'w') as outfile:
    outfile.writelines ( new_rules )
