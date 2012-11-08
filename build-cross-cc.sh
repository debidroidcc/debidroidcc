#!/bin/bash

set -e

export PREFIX=/usr/local/cross-cc
export SRC_ROOT=~
export BUILD=arm-linux-gnueabihf
export HOST=arm-linux-gnueabihf
export TARGET=i686-pc-linux-gnu
export BUILDDIR=$SRC_ROOT/build

mkdir -p $BUILDDIR

cd $BUILDDIR
wget http://ftp.gnu.org/gnu/binutils/binutils-2.23.tar.gz
tar -xzf binutils-2.23.tar.gz
cd binutils-2.23
./configure --with-included-gettext \
	--target=$TARGET --host=$HOST --build=$BUILD \
	--prefix=$PREFIX -v
make
sudo make install

# missing here: glibc

cd $BUILDDIR
wget http://ftp.gnu.org/gnu/gcc/gcc-4.6.2/gcc-4.6.2.tar.gz
tar -xzf gcc-4.6.2.tar.gz
cd gcc-4.6.2
./configure --enable-languages=c,c++ \
	--with-included-gettext --enable-shared \
	--enable-threads=posix \
	--with-headers=$PREFIX/i686-pc-linux-gnu/include/ \
	--target=$TARGET --host=$HOST --build=$BUILD \
	--prefix=$PREFIX -v
make
sudo make install

