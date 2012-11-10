#!/bin/bash

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
wget http://ftp.gnu.org/gnu/binutils/binutils-2.23.tar.gz
tar -xzf binutils-2.23.tar.gz
cd $BUILDDIR
$SRCDIR/binutils-2.23/configure --with-included-gettext \
	--target=$TARGET --host=$HOST --build=$BUILD \
	--prefix=$PREFIX -v
make
sudo make install
rm -rf * .*

# missing here: glibc

cd $SRCDIR
wget http://ftp.gnu.org/gnu/gcc/gcc-4.6.2/gcc-4.6.2.tar.gz
tar -xzf gcc-4.6.2.tar.gz
cd $BUILDDIR
$SRCDIR/gcc-4.6.2/configure --enable-languages=c,c++ \
	--with-included-gettext --enable-shared \
	--enable-threads=posix \
	--with-headers=$PREFIX/i686-pc-linux-gnu/include/ \
	--target=$TARGET --host=$HOST --build=$BUILD \
	--prefix=$PREFIX -v
make
sudo make install
rm -rf * .*
