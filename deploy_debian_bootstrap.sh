#!/system/bin/sh

# this must be executed as superuser
# debian is then deployed in the /data directory

# break on errors:
set -e

# some constants:
debootstrap_file_url=http://debian-armhf-bootstrap.googlecode.com/files/debian_bootstrap.tar.gz
busybox=/system/xbin/busybox
target_mountpoint=/data # this one might be derived from the $target_dir via df or mount
target_dir=$target_mountpoint
debian_dir=$target_dir/debian

# remount target mountpoint
$busybox mount -o remount,exec,dev,suid $target_mountpoint

# unpack bootstrapped debian:
cd $target_dir
$busybox wget -O debian_bootstrap.tar.gz $debootstrap_file_url
$busybox tar -xzf debian_bootstrap.tar.gz
$busybox rm debian_bootstrap.tar.gz

# second stage:
export PATH=/usr/bin:/usr/sbin:/bin:$PATH
export HOME=/root
$busybox chroot $debian_dir /debootstrap/debootstrap --second-stage

# config stuff:
echo 'deb http://ftp.us.debian.org/debian/ sid main contrib non-free' >> $debian_dir/etc/apt/sources.list
echo 'nameserver 8.8.8.8' >> $debian_dir/etc/resolv.conf

# some useful mounts
$busybox chroot $debian_dir /bin/mount -t devpts devpts /dev/pts
$busybox chroot $debian_dir /bin/mount -t proc proc /proc
$busybox chroot $debian_dir /bin/mount -t sysfs sysfs /sys

#spawn login shell
$busybox chroot $debian_dir /bin/bash -l

