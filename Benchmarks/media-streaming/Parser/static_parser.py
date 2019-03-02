#!/usr/bin/env python
import io
import sys
from collections import OrderedDict

current_dir = "media-streaming"
current_dir = current_dir.lower()

pwd = "/home/ubuntu/SecureWilly/Benchmarks/media-streaming/Parser"
pre_pwd = "/home/ubuntu/SecureWilly/Benchmarks/media-streaming"

#This will be our preliminery profile from Static Analysis. Append every rule extracted to it.
static_profile = []

#Rules
#We prepare some fixed rules that will be added below under the right conditions

#This rule is needed so that we can work with files in containers and handling containers filesystem
file_rule = '\tfile,  #Allows access to containers filesystem\n'

#These rules are needed so that we can switch between users
setuid_setgid_rule = '\tcapability setuid,  #Needed to switch between users (chown or USER commands)\n\tcapability setgid,  #Needed to switch between users (chown or USER commands)\n'
deny_setuid_setgid_rule = '\tdeny capability setuid,  #Deny capability to create new login session\n\tdeny capability setgid,  #Deny capability to create new login session\n'

#Chown capability
chown_cap = '\tcapability chown,  #This capability is needed to use chown\n'

#Docker rule is needed in every container so it has access to its filesystem layers
docker_rule = '\t/var/lib/docker/* r, #Access to layers of filesystem\n'

#Deny ptrace rule to confront container breakouts
deny_ptrace_rule = '\tdeny ptrace (readby, tracedby), #Confront container breakout attacks\n'

#These rules are added by default to every profile
static_profile.append(file_rule)
static_profile.append(docker_rule)
static_profile.append(deny_ptrace_rule)

#-------------------------------------Dockerfile-------------------------------------------------
dockerfile = str(sys.argv[1])

#If there is no dockerfile provided, SecureWilly_API gives an empty file as argument
with open(dockerfile,'r') as infile:
    data = infile.readlines()

#Keywords to search for in Dockerfile
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
expose = 'EXPOSE'

#Parse the whole file, line per line
for line in data:

    #Exposed ports
    if expose in line:
        line = line.split(' ')
        port_proto = line[1]
        if 'udp' in port_proto:
            proto='udp'
        else:
            proto='tcp'
        #At the time we strip the protocol
        #When the bind rule is supported in AppArmor
        #We will fix this if it's actually needed in the rule
        port_cont = port_proto.replace(proto, '')
        port_cont = port_cont.replace('/','')
        port_cont = port_cont.strip('\n')
        ports_rule='\tnetwork ' + proto + ',\n #Allowing networking with forwarding ports' 
        static_profile.append(ports_rule)
                
        #port refers to container's port
        #In order for an app to bind to ports < 1024 capability net bind service is needed
        if int(port_cont) < 1024:
            static_profile.append('\tcapability net_bind_service,  #This capability is needed to bind a socket to Internet domain privileged ports\n')


    #Users
    #There should be permission to switch only to this user but athough it is given in the documentation, this specification is not yet implemented:
    #setuid -> userA
    #static_profile.append(setuid_setgid_rule)
    if user1 in line:
        #USER found. Augment the counter and keep the name in names list
        line = line.strip('\n')
        line = line.split(' ')
        user1_counter+=1
        user1_names.append(line[1])

    if user2 in line:
        #Run useradd found: Augment the counter and keep the name in names list
        #There should be permission to switch only to this user but athough it is given in the documentation, this specification is not yet implemented:
        #setuid -> userA
        #static_profile.append(setuid_setgid_rule)
        line = line.strip('\n')
        line = line.split(' ')
        user2_counter+=1
        user2_names.append(line[2])

    if chmod in line:
        #Chmod found so we have to deal with files (file rule) and fix permission bits
	line = line.strip('\n')
	line = line.split(' ')
	#flags TODO s = line[1].split('-', 1)

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

        static_profile.append(chmod_owner)
        static_profile.append(chmod_others)

    #if chown in line:
    #Chown command found so we need file rule, setuid rule and permission bits - if given

    #Add capability rule if we want to allow chown command to be used in the container
    #Not needed. Do it only if it is asked
    #static_profile.append('\tcapability chown,\n')

        #static_profile.append(setuid_setgid_rule)

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

#Count number of users used and added in Dockerfile to determine if there should be a switching at the image or not
if user1_counter>1:
    static_profile.append(setuid_setgid_rule)
if user2_counter==1:
    if user1_counter==1:
        if user1_names[0]!=user2_names[0]:
            static_profile.append(setuid_setgid_rule)
    else:
        #This is about 0 USER commands (>1 is already taken into account)
        static_profile.append(setuid_setgid_rule)
if user2_counter>1:
    static_profile.append(setuid_setgid_rule)
    


#-------------------------------------DockerCompose-------------------------------------

all_capabilities = ['audit_control', 'audit_write', 'chown', 'dac_override', 'dac_read_search', 'fowner', 'fsetid', 'kill', 'ipc_lock', 'ipc_owner', 'lease', 'linux_immutable', 'mac_admin', 'mac_override', 'mknod', 'net_admin', 'net_bind_service', 'net_broadcast', 'net_raw', 'setgid', 'setpcap', 'setuid', 'sys_admin', 'sys_boot', 'sys_chroot', 'sys_module', 'sys_nice', 'sys_pacct', 'sys_ptrace', 'sys_rawio', 'sys_resource', 'sys_time', 'sys_tty_config', 'setfcap']

dockercompose = str(sys.argv[2])
#If no docker-compose is provided, SecureWilly_API will create one by the docker run flags given by user

with open(dockercompose,'r') as infile:
        data = infile.readlines()

network = 'ports:'
expose = 'expose:'
mount = 'volumes:'
capability = 'cap_add:'
capability_deny = 'cap_drop:'
ulimit = 'ulimits'
	
for i in xrange(len(data)): #because we will need the next line
    if network in data[i]:
        z = i
	while ('-' in data[z+1]): #checking for multiple ports (same with volumes, capabilities etc)
	    ports = data[z+1].strip()
            if 'udp' in ports:
                proto='udp'
            else:
                proto='tcp'
            #At the time we strip the protocol
            #When the bind rule is supported in AppArmor
            #We will fix this if it's actually needed in the rule
            ports = ports.replace(proto,'')
            ports = ports.replace('/','')
            ports = ports.strip('\n')
	    ports = ports.strip('"')
            if ':' in ports:
	        ports = ports.split(':')
	        port_host = ports[0].strip('-')
	        port_host = port_host.strip()
	        port_host = port_host.strip('"')
	        port_container = ports[1]
            else:
                port_container = ports
                                
            if int(port_container) < 1024: #In order for an app to bind to ports < 1024 capability net bind service is needed
                static_profile.append('\tcapability net_bind_service,  #This capability is needed to bind a socket to Internet domain privileged ports\n')

	    #bind_rule = '\tnetwork bind ' + port_host + ' to ' + port_container + ',\n' NOT SUPPORTED YET
	    static_profile.append('\tnetwork ' + proto + ',  #Grain access to networking - ports forwarding\n')
	    z = z+1

    if expose in data[i]:
        z = i
        while ('-' in data[z+1]): #checking for multiple ports (same with volumes, capabilities etc)
            port = data[z+1].strip()
            if 'udp' in ports:
                proto='udp'
            else:
                proto='tcp'
            port = port.replace(proto, '')
            port = port.replace('/','')
            port = port.strip('\n')
            port = port.strip('"')
            if int(port) < 1024: #In order for an app to bind to ports < 1024 capability net bind service is needed
                static_profile.append('\tcapability net_bind_service,  #This capability is needed to bind a socket to Internet domain privileged ports\n')
            static_profile.append('\tnetwork ' + proto + ',  #Grain access to networking - ports forwarding\n')
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

            if (mntpnt.endswith('/')):
                mntpnt = mntpnt.rstrip('/')

            #If source does not start with / then it is one of the following
            #Relative path . -> pwd
            #Relative path .. -> father of pwd
            #Not a path but a named volume
            #So we change it into the real host path
            if (src.startswith('..')):
                src = pwd_dir
            elif (src.startswith('.')):
                src = pre_pwd
            elif (not src.startswith('/')):
                src="/var/lib/docker/volumes/" + current_dir + "_" + src + "/_data"

            #If there is a mount option:
            if len(src_mntpnt)==3:
                option = src_mntpnt[2]
                if 'ro' in option:
                    ro_rule = '\tdeny ' + mntpnt + ' w,\n'
                    static_profile.append(ro_rule)
                    mount_rule = '\tmount options=ro ' + src + ' -> ' + mntpnt + ', #Bind host volume to docker container volume\n'
                    file_mnt_rule = '\t' + mntpnt + '/* r,\n'
                else:
                    mount_rule = '\tmount ' + src + ' -> ' + mntpnt + ', #Bind host volume to docker container volume\n'
                    file_mnt_rule = '\t' + mntpnt + '/* rw,\n'
            else:
		mount_rule = '\tmount ' + src + ' -> ' + mntpnt + ', #Bind host volume to docker container volume\n'
                file_mnt_rule = '\t' + mntpnt + '/* rw,\n'

            if mntpnt == '': 
                #Then it was root's dir and we stripped of the /
                mntpnt = '/'

            umount_rule = '\tdeny umount ' + mntpnt + ', #Disallow anybody that wants to break this mountpoint\n'
	    remount_rule = '\tdeny remount '+ mntpnt + ', #Disallow anybody that wants to remount this mountpoint\n'
            static_profile.append(mount_rule)
            static_profile.append(umount_rule)
            static_profile.append(remount_rule)
            static_profile.append(file_mnt_rule)
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

    if capability in data[i]:
        z = i
	while ('-' in data[z+1]):
	    x = data[z+1].strip()
	    x = x.strip('-')
	    x = x.strip()
	    if x=='ALL':
                cap = '\tcapability, #Add all capabilities\n'
	        static_profile.append(cap)
	    else:
		x = x.lower()
		cap = '\tcapability ' + x + ',\n'
		static_profile.append(cap)
	    z = z+1

    if capability_deny in data[i]:
        z = i
	while ('-' in data[z+1]):
	    x = data[z+1].strip()
	    x = x.strip('-')
	    x = x.strip()
	    if x=='ALL':
                cap = '\tdeny capability, #Drop all capabilities\n'
	        static_profile.append(cap)
	    else:
		x = x.lower()
		cap = '\tdeny capability ' + x + ',\n'
		static_profile.append(cap)
	    z = z+1

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

#-------Static profile is ready--------

#Delete duplicate rules by converting list to set. Convert back to list to keep the order of the beggining and ending of a profile
#This is the way to delete duplicates, when we don't care about the order
static_profile = list(set(static_profile))

#Add the beggining and ending of the profile
#beggining
static_profile.insert(0, '#include <tunables/global>\n\nprofile static_profile flags=(attach_disconnected,mediate_deleted) {\n\n')
#ending
static_profile.append('}\n')

#Output
with open('static_profile', 'w') as outfile:
    outfile.writelines( static_profile )

