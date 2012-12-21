#!/system/bin/sh

# break on errors:
set -e

# some constants:
busybox=/system/xbin/busybox
target_mountpoint=/data # this one might be derived from the $target_dir via df or mount
target_dir=$target_mountpoint
debian_dir=$target_dir/debian

# remount target mountpoint
$busybox mount -o remount,exec,dev,suid $target_mountpoint

# second stage:
export PATH=/usr/bin:/usr/sbin:/bin:$PATH
export HOME=/root

# some useful mounts
$busybox chroot $debian_dir /bin/mount -t devpts devpts /dev/pts
$busybox chroot $debian_dir /bin/mount -t proc proc /proc
$busybox chroot $debian_dir /bin/mount -t sysfs sysfs /sys

#spawn login shell
$busybox chroot $debian_dir /bin/bash -l

