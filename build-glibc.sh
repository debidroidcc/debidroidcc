#!/bin/bash

# this stuff is to be executed on a x86 machine 
# (or with a cross compiler generating x86 code)
# in order to get the appropriate binary

set -e

export PREFIX=/usr/local/cross-cc
export SRC_ROOT=~
export BUILD=arm-linux-gnueabihf
export HOST=arm-linux-gnueabihf
export TARGET=i686-pc-linux-gnu
export SRCDIR=$SRC_ROOT/cross-cc
export BUILDDIR=$SRCDIR/build

mkdir -p $BUILDDIR

cd $SRCDIR
wget -c http://ftp.gnu.org/gnu/glibc/glibc-2.16.0.tar.gz
tar -xzf glibc-2.16.0.tar.gz
cd $BUILDDIR
$SRCDIR/glibc-2.16.0/configure --enable-addons --prefix=$PREFIX/$TARGET
make -j 4
sudo make install
cd $PREFIX
tar -czf $SRC_ROOT/glibc-$TARGET-prefixed.tar.gz $TARGET
