#!/bin/bash

set -e

export PREFIX=/usr/local/cross-cc
export SRC_ROOT=~
export BUILD=arm-linux-gnueabihf
export HOST=arm-linux-gnueabihf
export SRCDIR=$SRC_ROOT/cross-cc

mkdir -p $SRCDIR
cd $SRCDIR

unset ARCH
ARCH=i386

sudo sh -c "echo 'deb-src http://ftp.us.debian.org/debian unstable main contrib non-free' > /etc/apt/sources.list.d/unstable-sources.list"
sudo apt-get update

apt-get source binutils gcc-4.6
sudo apt-get build-dep binutils gcc-4.6
sudo apt-get install fakeroot
sudo apt-get install dpkg-cross

# build binutils
cd binutils*
export TARGET=$(dpkg-architecture -a$ARCH -qDEB_HOST_GNU_TYPE 2>/dev/null)
