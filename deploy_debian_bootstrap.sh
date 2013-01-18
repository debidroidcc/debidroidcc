#!/system/bin/sh

# this must be executed as superuser
# a recent busybox (i used 1.20.2 as 1.19 did not work) is required in /system/xbin too
# debian is then deployed in the /data/debian directory

# break on errors:
set -e

# display commands:
set -x

# some constants:
debootstrap_file_url=http://debian-armhf-bootstrap.googlecode.com/files/debian_bootstrap.tar.gz
#busybox=/system/xbin/busybox
busybox=/data/data/de.tubs.ibr.distcc/app_bin/busybox
target_mountpoint=/data # this one might be derived from the $target_dir via df or mount
target_dir=$target_mountpoint
debian_dir=$target_dir/debian

# remount target mountpoint
echo "Remounting $target_mountpoint"
$busybox mount -o remount,exec,dev,suid $target_mountpoint

# unpack bootstrapped debian:
cd $target_dir
echo "downloading debian_bootstrap.tar.gz"
$busybox wget -O debian_bootstrap.tar.gz $debootstrap_file_url
echo "untaring..."
$busybox tar -xzf debian_bootstrap.tar.gz
$busybox rm debian_bootstrap.tar.gz

# second stage:
export PATH=/usr/bin:/usr/sbin:/bin:$PATH
export HOME=/root
$busybox chroot $debian_dir /debootstrap/debootstrap --second-stage

# config stuff:
echo 'deb http://ftp.us.debian.org/debian/ unstable main contrib non-free' >> $debian_dir/etc/apt/sources.list
echo 'nameserver 8.8.8.8' >> $debian_dir/etc/resolv.conf

# some useful mounts
$busybox chroot $debian_dir /bin/mount -t devpts devpts /dev/pts
$busybox chroot $debian_dir /bin/mount -t proc proc /proc
$busybox chroot $debian_dir /bin/mount -t sysfs sysfs /sys

# important: enable networking for root user
$busybox chroot $debian_dir /usr/sbin/groupadd -g 3003 inet
$busybox chroot $debian_dir /usr/sbin/usermod -a -G inet root

# apt-get stuff
# all the commands are now displayed anyway as of 'set -x'
$busybox chroot $debian_dir /usr/bin/apt-get update
$busybox chroot $debian_dir /usr/bin/apt-get -y upgrade
$busybox chroot $debian_dir /usr/bin/apt-get -y install wget unzip

# download the whole scripts repository:
$busybox chroot $debian_dir /usr/bin/wget --no-check-certificate -O /root/debidroidcc.zip https://github.com/debidroidcc/debidroidcc/archive/master.zip
$busybox chroot $debian_dir /usr/bin/unzip -o /root/debidroidcc.zip -d /root

# setting up the cross-compiler is now outsourced to a dedicated script:
$busybox chroot $debian_dir /bin/bash /root/debidroidcc-master/setup-cross-cc-in-chroot.sh

# ...as is the setup of the ssh server...
$busybox chroot $debian_dir /bin/bash /root/debidroidcc-master/setup-sshd-in-chroot.sh

# ...and distcc:
# doesn't work: $busybox chroot $debian_dir /bin/bash /root/debidroidcc-master/setup-distcc-in-chroot.sh

# other services such as avahi, sysklogd, inadyn, too:
# doesn't work: $busybox chroot $debian_dir /bin/bash /root/debidroidcc-master/setup-services-in-chroot.sh

# finally, start all the services:
$busybox chroot $debian_dir /bin/bash /root/debidroidcc-master/after-reboot-inside-chroot.sh

# and clean the apt cache:
$busybox chroot $debian_dir /usr/bin/apt-get clean

# spawn login shell
# $busybox chroot $debian_dir /bin/bash -l
