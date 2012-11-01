#!/system/bin/sh

# this must be executed as superuser
# debian is then deployed in the /data directory

busybox=/system/xbin/busybox
target_dir=/data
debian_dir=$target_dir/debian

cd $target_dir
$busybox tar -xzf debian_bootstrap.tar.gz

export PATH=/usr/bin:/usr/sbin:/bin:$PATH
export HOME=/root
$busybox chroot $debian_dir /debootstrap/debootstrap --second-stage

# config stuff
echo 'deb http://ftp.us.debian.org/debian sid main' >> $debian_dir/etc/apt/sources.list
echo 'nameserver 8.8.8.8' >> $debian_dir/etc/resolv.conf

# some useful mounts
$busybox chroot $debian_dir /bin/mount -t devpts devpts /dev/pts
$busybox chroot $debian_dir /bin/mount -t proc proc /proc
$busybox chroot $debian_dir /bin/mount -t sysfs sysfs /sys

#spawn login shell
$busybox chroot $debian_dir /bin/bash -l

