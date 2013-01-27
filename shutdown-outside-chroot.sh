#!/system/bin/sh

# break on errors:
#set -e

# display commands:
set -x

#busybox=/system/xbin/busybox
if [ -z $busybox ]; then
	busybox=/data/data/de.tubs.ibr.distcc/app_bin/busybox
fi
if [ -z $target_mountpoint ]; then
	target_mountpoint=/data # this one might be derived from the $target_dir via df or mount
fi
if [ -z $target_dir ]; then
	target_dir=$target_mountpoint
fi
if [ -z $debian_dir ]; then
	debian_dir=$target_dir/debian
fi

# set paths
export PATH=/usr/bin:/usr/sbin:/bin:$PATH
export HOME=/root

# kill all ssh sessions
$busybox chroot $debian_dir /bin/bash -c "/usr/bin/killall sshd"

# stop services
$busybox chroot $debian_dir /etc/init.d/ssh stop
$busybox chroot $debian_dir /etc/init.d/distcc stop
$busybox chroot $debian_dir /etc/init.d/dbus stop

# make sure it is really dead
$busybox chroot $debian_dir /usr/bin/killall distccd

# unmount virtual filesystems
$busybox chroot $debian_dir /bin/umount /dev/pts
$busybox chroot $debian_dir /bin/umount /proc
$busybox chroot $debian_dir /bin/umount /sys
