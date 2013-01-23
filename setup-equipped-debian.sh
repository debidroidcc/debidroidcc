#!/system/bin/sh

# break on errors:
set -e

# display commands:
set -x

debian_filename=equipped_debian_chroot.tar.bz2
equipped_debian_file_url=http://debian-armhf-bootstrap.googlecode.com/files/$debian_filename
#busybox=/system/xbin/busybox
busybox=/data/data/de.tubs.ibr.distcc/app_bin/busybox
target_mountpoint=/data # this one might be derived from the $target_dir via df or mount
target_dir=$target_mountpoint
debian_dir=$target_dir/debian

echo "Remounting $target_mountpoint"
$busybox mount -o remount,exec,dev,suid $target_mountpoint

cd $target_dir
echo "downloading $debian_filename"
$busybox wget -O $debian_filename $equipped_debian_file_url
echo "unpacking..."
$busybox tar -xjf $debian_filename
$busybox rm $debian_filename

export PATH=/usr/bin:/usr/sbin:/bin:$PATH
export HOME=/root

# some useful mounts
$busybox chroot $debian_dir /bin/mount -t devpts devpts /dev/pts
$busybox chroot $debian_dir /bin/mount -t proc proc /proc
$busybox chroot $debian_dir /bin/mount -t sysfs sysfs /sys

# download the whole scripts repository:
$busybox chroot $debian_dir /usr/bin/wget --no-check-certificate -O /root/debidroidcc.zip https://github.com/debidroidcc/debidroidcc/archive/master.zip
$busybox chroot $debian_dir /usr/bin/unzip -o /root/debidroidcc.zip -d /root

# finally, start all the services:
$busybox chroot $debian_dir /bin/bash /root/debidroidcc-master/after-reboot-inside-chroot.sh
