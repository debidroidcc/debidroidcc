#!/system/bin/sh

# break on errors:
set -e

# display commands:
set -x

#busybox=/system/xbin/busybox
busybox=/data/data/de.tubs.ibr.distcc/app_bin/busybox
target_mountpoint=/data # this one might be derived from the $target_dir via df or mount
target_dir=$target_mountpoint
debian_dir=$target_dir/debian

# set paths
export PATH=/usr/bin:/usr/sbin:/bin:$PATH
export HOME=/root

# some useful mounts
$busybox chroot $debian_dir /bin/mount -t devpts devpts /dev/pts
$busybox chroot $debian_dir /bin/mount -t proc proc /proc
$busybox chroot $debian_dir /bin/mount -t sysfs sysfs /sys

# finally, start all the services:
$busybox chroot $debian_dir /bin/bash /root/debidroidcc-master/after-reboot-inside-chroot.sh
