#!/usr/bin/env python
import io
import sys
from collections import OrderedDict

#Function used to delete duplicates from a list - profile rules in our case
def ordered_set(in_list):
    out_list = []
    added = set()
    for val in in_list:
        if not val in added:
            out_list.append(val)
            added.add(val)
    return out_list

static_profile = []

#Dockerfile
dockerfile = str(sys.argv[1])

with open(dockerfile,'r') as infile:
	data = infile.readlines()

#Rules

#This rule is needed so that we can work with files (create files/directories, copy, etc)
file_rule = '\tfile,  #This rule is needed so that I can work with files (create files/directories, copy, etc)\n'

#These rules are needed so that we can switch between users
setuid_setgid_rule = '\tcapability setuid,  #Needed to switch between users (chown or USER commands)\n\tcapability setgid,  #Needed to switch between users (chown or USER commands)\n'
deny_setuid_setgid_rule = '\tdeny capability setuid,  #Deny capability to create new login session\n\tdeny capability setgid,  #Deny capability to create new login session\n'

#Chown capability
chown_cap = '\tcapability chown,  #This capability is needed to use chown\n'

#Docker rule is needed in every container
docker_rule = '\t/var/lib/docker/* r, #Access to layers of filesystem\n'

#Deny ptrace rule to confront container breakouts
deny_ptrace_rule = '\tdeny ptrace (readby, tracedby), #Confront container breakout attacks\n'

static_profile.append(file_rule)
static_profile.append(docker_rule)
static_profile.append(deny_ptrace_rule)

#Search for chmod or chown in Dockerfile
chmod = 'RUN chmod'
chown = 'RUN chown'
user1 = 'USER'
user1_names = []
user1_counter = 0
user2 = 'RUN useradd'
user2_names = []
user2_counter = 0
copy = 'COPY'
add = 'ADD'

for line in data:

        if user2 in line:
        #USER command is found so we consider that there must be given the permission to switch between users
        #There should be permission to switch only to this user but athough it is given in the documentation, this specification is not yet implemented:
        #setuid -> userA
                #static_profile.append(setuid_setgid_rule)
                line = line.strip('\n')
                line = line.split(' ')
                user2_counter+=1
                user2_names.append(line[2])

        if user1 in line:
                line = line.strip('\n')
                line = line.split(' ')
                user1_counter+=1
                user1_names.append(line[1])

	if chmod in line:
        #Chmod found so we have to deal with files (file rule) and fix sticky bits and permissions
		line = line.strip('\n')
		line = line.split(' ')
		#flags	TODO	s = line[1].split('-', 1)

                #Chmod Rule - not supported 
		#Add the right permissions to owner of the file and others

		#Path permission rule - File access rule
                chmod_path = line[len(line)-1]
		chmod_permission = list(line[len(line)-2])


                #chmod permissions calculate both for letters and numbers. ONLY FOR OWNER and OTHERS. Not supported for owning group!
		if chmod_permission[0] == 'u':
			owner = line[len(line)-2].split('+')
		if chmod_permission[0] == '1':
			owner = 'ix'
		if chmod_permission[0] == '2':
			owner = 'w'
		if chmod_permission[0] == '3':
			owner = 'wix'
		if chmod_permission[0] == '4':
			owner = 'r'
		if chmod_permission[0] == '5':
			owner = 'rix'
		if chmod_permission[0] == '6':
			owner = 'rw'
		if chmod_permission[0] == '7':
			owner = 'rwix'

                if chmod_permission[2] == 'u':
                        others = line[len(line)-2].split('+')
                if chmod_permission[2] == '1':
                        others = 'ix'
                if chmod_permission[2] == '2':
                        others = 'w'
                if chmod_permission[2] == '3':
                        others = 'wix'
                if chmod_permission[2] == '4':
                        others = 'r'
                if chmod_permission[2] == '5':
                        others = 'rix'
                if chmod_permission[2] == '6':
                        others = 'rw'
                if chmod_permission[2] == '7':
                        others = 'rwix'

                #Owner's permissions
		chmod_owner = '\towner ' + chmod_path + ' ' + owner + ',\n'
                #Others' permissions
                chmod_others = '\t' + chmod_path + ' ' + others  + ',\n'

                chmod_rule = '\t#Chmod command\n' + chmod_owner + chmod_others + '\n'
                static_profile.append(chmod_rule)
                static_profile.append(file_rule)

	if chown in line:
        #Chown command found so we need file rule, setuid rule and sticky bits - if given

		#Add capability rule if we want to allow chown command to be used in the container
                #Not needed. Do it only if it is asked
                #static_profile.append('\tcapability chown,\n')

                static_profile.append(file_rule)
                static_profile.append(setuid_setgid_rule)

		#Not supported!
		#Chown Rule needed as well
		#line = line.strip('\n')
		#line = line.split(' ')
		#path = line[len(line)-1]
		#owner_group = line[len(line)-2]
		#owner_group = owner_group.split(':')
		#owner = owner_group[0]
		#if len(owner_group) == 2:
		#	group = owner_group[1]
		#	chown_rule = '\tchown ' + path + ' to owner=' + owner + ' group=' + group + ',\n'
		#else:
		#	chown_rule = '\tchown ' + path + ' to owner=' + owner + ',\n'
		#Add chown rule
		#static_profile.append(chown_rule)

	if (copy or add) in line:
        #This means we are dealing with directories and files so we need file rule
		static_profile.append(file_rule)

if user1_counter>1:
    static_profile.append(setuid_setgid_rule)
if user2_counter==1:
    if user1_counter==1:
        if user1_names[0]!=user2_names[0]:
            static_profile.append(setuid_setgid_rule)
    else:
        static_profile.append(setuid_setgid_rule)
if user2_counter>1:
    static_profile.append(setuid_setgid_rule)
    


#DockerCompose - if it exists
if (len(sys.argv) > 2):
	all_capabilities = ['audit_control', 'audit_write', 'chown', 'dac_override', 'dac_read_search', 'fowner', 'fsetid', 'kill', 'ipc_lock', 'ipc_owner', 'lease', 'linux_immutable', 'mac_admin', 'mac_override', 'mknod', 'net_admin', 'net_bind_service', 'net_broadcast', 'net_raw', 'setgid', 'setpcap', 'setuid', 'sys_admin', 'sys_boot', 'sys_chroot', 'sys_module', 'sys_nice', 'sys_pacct', 'sys_ptrace', 'sys_rawio', 'sys_resource', 'sys_time', 'sys_tty_config', 'setfcap']

	dockercompose = str(sys.argv[2])
	with open(dockercompose,'r') as infile:
		data = infile.readlines()

	#data.append('')
	network = 'ports:'
	mount = 'volumes:'
	mount_ = 'volume_driver:'
	capability = 'cap_add:'
	capability_deny = 'cap_drop:'
	ulimit = 'ulimits'
	
	for i in xrange(len(data)): #because we will need the next line
		if network in data[i]:
                        #static_profile.append(file_rule)
			z = i
			while ('-' in data[z+1]): #checking for multiple ports (same with volumes, capabilities etc)
				ports = data[z+1].strip()
				ports = ports.strip('"')
				ports = ports.split(':')
				port_host = ports[0].strip('-')
				port_host = port_host.strip()
				port_host = port_host.strip('"')
				port_container = ports[1]
                                
                                if int(port_container) < 1024: #In order for an app to bind to ports < 1024 capability net bind service is needed
                                    static_profile.append('\tcapability net_bind_service,  #This capability is needed to bind a socket to Internet domain privileged ports\n')

				#bind_rule = '\tnetwork bind ' + port_host + ' to ' + port_container + ',\n' NOT SUPPORTED
				static_profile.append('\tnetwork,  #Grain access to networking - ports forwarding\n')
				z = z+1
		if mount in data[i]:
			z = i
			while ('-' in data[z+1]):
				src_mntpnt = data[z+1].strip()
				src_mntpnt = src_mntpnt.strip('"')
				src_mntpnt = src_mntpnt.split(':')
				src = src_mntpnt[0].strip('-')
				src = src.strip()
				src = src.strip('"')
				mntpnt = src_mntpnt[1]

                                #If there is a mount option:
                                if len(src_mntpnt)==3:
                                    option = src_mntpnt[2]
                                    if 'ro' in option:
                                        ro_rule = '\tdeny ' + mntpnt + ' w,\n'
                                        static_profile.append(ro_rule)
                                        mount_rule = '\tmount options=ro ' + src + ' -> ' + mntpnt + ', #Bind host volume to docker container volume\n'
                                    else:
                                        mount_rule = '\tmount ' + src + ' -> ' + mntpnt + ', #Bind host volume to docker container volume\n'
                                else:
				    mount_rule = '\tmount ' + src + ' -> ' + mntpnt + ', #Bind host volume to docker container volume\n'

                                umount_rule = '\tdeny umount ' + mntpnt + ', #Disallow anybody that wants to break this mountpoint\n'
				remount_rule = '\tdeny remount '+ mntpnt + ', #Disallow anybody that wants to remount this mountpoint\n'
                                static_profile.append(mount_rule)
                                static_profile.append(umount_rule)
                                static_profile.append(remount_rule)
				z = z+1
                            #If docker.sock is mounted in one of the following ways, deny capabilities setuid and setgid so the user won't be able to start a new login session
                                if src=='/':
                                    static_profile.append(deny_setuid_setgid_rule)
                                else:
                                    if (src.endswith('/')):
                                        src = src.rstrip('/')
                                    if src=='/var':
                                        static_profile.append(deny_setuid_setgid_rule)
                                    if src=='/var/run':
                                        static_profile.append(deny_setuid_setgid_rule)
                                    if src=='/var/run/docker.sock':
                                        static_profile.append(deny_setuid_setgid_rule)
                        static_profile.append(file_rule)
		if capability in data[i]:
			z = i
			while ('-' in data[z+1]):
				x = data[z+1].strip()
				x = x.strip('-')
				x = x.strip()
				if x=='ALL':
					#for j in xrange(len(all_capabilities)):
						#cap = '\tcapability ' + all_capabilities[j] + ',\n'
                                        cap = '\tcapability, #Add all capabilities\n'
					static_profile.append(cap)
				else:
					x = x.lower()
					cap = '\tcapability ' + x + ',\n'
					static_profile.append(cap)
				z = z+1
			static_profile.append('\n')
		if capability_deny in data[i]:
			z = i
			while ('-' in data[z+1]):
				x = data[z+1].strip()
				x = x.strip('-')
				x = x.strip()
				if x=='ALL':
					#for j in xrange(len(all_capabilities)):
						#cap = '\tdeny capability ' + all_capabilities[j] + ',\n'
                                        cap = '\tdeny capability, #Drop all capabilities\n'
					static_profile.append(cap)
				else:
					x = x.lower()
					cap = '\tdeny capability ' + x + ',\n'
					static_profile.append(cap)
				z = z+1
			static_profile.append('\n')
		if ulimit in data[i]:
                        z = i+1;
                        my_ulimit = data[z].strip()
                        my_ulimit = my_ulimit.strip(":")
                        slimits = data[z+1].split(':')
                        soft = slimits[1].strip()
                        hlimits = data[z+2].split(':')
                        hard = hlimits[1].strip()
                        #TODO More than one ulimits
                        #TODO Single value ulimit (this is hard limit)
                        ulimit_rule = "\tset rlimit " + my_ulimit + " <= " + hard + ",\n"
                        static_profile.append(ulimit_rule)
                        z = z+3
                        
			
			
#static_profile.append('}\n')

#Delete duplicate rules by converting list to set. Convert back to list to keep the order of the beggining and ending of a profile
#This is the way to delete duplicates, when we don't care about the order
static_profile = list(set(static_profile))

#Delete duplicates, but keeping the order JUST FOR THE PRESENTATION in order to show the extracted rules from the correct orders
#static_profile = ordered_set(static_profile)

#Add the beggining and ending of the profile - do it in both inordered and not inoerdered lists
#beggining
static_profile.insert(0, '#include <tunables/global>\n\nprofile static_profile flags=(attach_disconnected,mediate_deleted) {\n\n')
#ending
static_profile.append('}\n')


#Output
with open('static_profile', 'w') as outfile:
	outfile.writelines( static_profile )

