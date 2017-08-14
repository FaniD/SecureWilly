#!/usr/bin/env python
import io
import sys

profile = []
profile.append('#include <tunables/global>\n\n')
profile.append('profile new {\n')

#Dockerfile
dockerfile = str(sys.argv[1])

with open(dockerfile,'r') as infile:
	data = infile.readlines()

#Search for chmod or chown in Dockerfile
chmod = 'RUN chmod'
chown = 'RUN chown'

for line in data:
	if chmod in line: #chmod found
		line = line.strip('\n')
		line = line.split(' ')
		#flags	TODO	s = line[1].split('-', 1)
		#Chmod Rule
		chmod_rule = '\tchmod ' + line[len(line)-2] + ' ' + line[len(line)-1] + ',\n'

		#Path permission rule - File access rule
		chmod_permission = list(line[len(line)-2])
		chmod_path = line[len(line)-1]
		#chmod permissions calculate both for letters and numbers. ONLY FOR OWNER!
		if chmod_permission[1] == 'u':
			permissions = line[len(line)-2].split('+')
		if chmod_permission[1] == '1':
			permissions = 'x'
		if chmod_permission[1] == '2':
			permissions = 'w'
		if chmod_permission[1] == '3':
			permissions = 'wx'
		if chmod_permission[1] == '4':
			permissions = 'r'
		if chmod_permission[1] == '5':
			permissions = 'rx'
		if chmod_permission[1] == '6':
			permissions = 'rw'
		if chmod_permission[1] == '7':
			permissions = 'rwx'
		chmod_path_rule = '\t' + chmod_path + ' ' + permissions + ',\n'

		#Add rules to AppArmor profile
		profile.append(chmod_rule)
		profile.append(chmod_path_rule)

	if chown in line: #chown found
		#Add capability rule
		profile.append('\tcapability chown,\n')

		#Chown Rule needed as well
		line = line.strip('\n')
		line = line.split(' ')
		path = line[len(line)-1]
		owner_group = line[len(line)-2]
		owner_group = owner_group.split(':')
		owner = owner_group[0]
		if len(owner_group) == 2:
			group = owner_group[1]
			chown_rule = '\tchown ' + path + ' to owner=' + owner + ' group=' + group + ',\n'
		else:
			chown_rule = '\tchown ' + path + ' to owner=' + owner + ',\n'
		#Add chown rule
		profile.append(chown_rule)

#	if (copy or add) in line:
#		line = line.split(' ')
#		src = line[1]
#		dst = line[2]
#		src = src + ' r,\n'
#		dst = dst + ' w,\n'
#		profile.append(src)
#		profile.append(dst)

profile.append('\n')

#DockerCompose - if it exists
if (len(sys.argv) > 2):
	all_capabilities = ['audit_control', 'audit_write', 'chown', 'dac_override', 'dac_read_search', 'fowner', 'fsetid', 'kill', 'ipc_lock', 'ipc_owner', 'lease', 'linux_immutable', 'mac_admin', 'mac_override', 'mknod', 'net_admin', 'net_bind_service', 'net_broadcast', 'net_raw', 'setgid', 'setpcap', 'setuid', 'sys_admin', 'sys_boot', 'sys_chroot', 'sys_module', 'sys_nice', 'sys_pacct', 'sys_ptrace', 'sys_rawio', 'sys_resource', 'sys_time', 'sys_tty_config', 'setfcap']

	dockercompose = str(sys.argv[2])
	with open(dockercompose,'r') as infile:
		data = infile.readlines()

	data.append('')
	network = 'ports:'
	mount = 'volumes:'
	mount_ = 'volume_driver:'
	capability = 'cap_add:'
	capability_deny = 'cap_drop:'
#	rlimit = 'cgroup_parent'
	
	for i in xrange(len(data)): #because we will need the next line
		if network in data[i]:
			profile.append('\tcapability net_bind_service,\n')
			z = i
			while ('-' in data[z+1]): #checking for multiple ports (same with volumes, capabilities etc)
				ports = data[z+1].strip()
				ports = ports.strip('"')
				ports = ports.split(':')
				port_host = ports[0].strip('-')
				port_host = port_host.strip()
				port_host = port_host.strip('"')
				port_container = ports[1]

				bind_rule = '\tnetwork bind ' + port_host + ' to ' + port_container + ',\n'
				profile.append(bind_rule)
				z = z+1
			profile.append('\n')
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
				mount_rule = '\tmount ' + src + ' -> ' + mntpnt + ',\n'
				profile.append(mount_rule)
				z = z+1
			profile.append('\n')
		if capability in data[i]:
			z = i
			while ('-' in data[z+1]):
				x = data[z+1].strip()
				x = x.strip('-')
				x = x.strip()
				if x=='ALL':
					for j in xrange(len(all_capabilities)):
						cap = '\tcapability ' + all_capabilities[j] + ',\n'
						profile.append(cap)
				else:
					x = x.lower()
					cap = '\tcapability ' + x + ',\n'
					profile.append(cap)
				z = z+1
			profile.append('\n')
		if capability_deny in data[i]:
			z = i
			while ('-' in data[z+1]):
				x = data[z+1].strip()
				x = x.strip('-')
				x = x.strip()
				if x=='ALL':
					for j in xrange(len(all_capabilities)):
						cap = '\tdeny capability ' + all_capabilities[j] + ',\n'
						profile.append(cap)
				else:
					x = x.lower()
					cap = '\tdeny capability ' + x + ',\n'
					profile.append(cap)
				z = z+1
			profile.append('\n')
		#if rlimit in line:
			
			
profile.append('}\n')
with open('profile', 'w') as outfile:
	outfile.writelines( profile )

