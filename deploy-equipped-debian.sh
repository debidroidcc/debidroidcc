#!/system/bin/sh

# break on errors:
set -e

# display commands:
set -x

debian_filename=equipped_debian_chroot.tar.bz2
equipped_debian_file_url=http://debian-armhf-bootstrap.googlecode.com/files/$debian_filename
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

echo "Remounting $target_mountpoint"
$busybox mount -o remount,exec,dev,suid $target_mountpoint

cd $target_dir
echo "downloading $debian_filename"
$busybox wget -O $debian_filename $equipped_debian_file_url
echo "unpacking..."
$busybox bzcat $debian_filename | $busybox tar -xf -
$busybox rm $debian_filename

export PATH=/usr/bin:/usr/sbin:/bin:$PATH
export HOME=/root

# some useful mounts
$busybox chroot $debian_dir /bin/mount -t devpts devpts /dev/pts
$busybox chroot $debian_dir /bin/mount -t proc proc /proc
$busybox chroot $debian_dir /bin/mount -t sysfs sysfs /sys

# set password (double escapes required in echo parameter)
$busybox chroot $debian_dir /bin/bash -c "echo -e \"debidroidcc\\ndebidroidcc\\n\" | passwd"

# download the whole scripts repository:
$busybox chroot $debian_dir /usr/bin/wget --no-check-certificate -O /root/debidroidcc.zip https://github.com/debidroidcc/debidroidcc/archive/master.zip
$busybox chroot $debian_dir /usr/bin/unzip -o /root/debidroidcc.zip -d /root

# enable zeroconf as it is not enabled in the tarball
$busybox chroot $debian_dir /bin/sed -i -e 's|ZEROCONF="false"|ZEROCONF="true"|g' /etc/default/distcc

# finally, start all the services:
$busybox chroot $debian_dir /bin/bash /root/debidroidcc-master/after-reboot-inside-chroot.sh
