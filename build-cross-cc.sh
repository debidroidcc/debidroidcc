#!/bin/bash

set -e

export PREFIX=/usr/local/cross-cc
export SRC_ROOT=/root
export BUILD=arm-linux-gnueabihf
export HOST=arm-linux-gnueabihf
export TARGET=i686-pc-linux-gnu
export SRCDIR=$SRC_ROOT/cross-cc
export BUILDDIR=$SRCDIR/build

mkdir -p $BUILDDIR

while getopts ":bgc" opt; do
  case $opt in
    b)
      echo "skipping binutils" >&2
	  SKIPBINUTILS=true
      ;;
	g)
      echo "skipping glibc" >&2
	  SKIPGLIBC=true
      ;;
	c)
      echo "skipping gcc" >&2
	  SKIPGCC=true
      ;;
	
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

sleep 1

if [ -z $SKIPBINUTILS ]; then
	cd $SRCDIR
	wget -c http://ftp.gnu.org/gnu/binutils/binutils-2.23.tar.gz
	tar -xzvf binutils-2.23.tar.gz
	cd $BUILDDIR
	$SRCDIR/binutils-2.23/configure --with-included-gettext \
		--target=$TARGET --host=$HOST --build=$BUILD \
		--prefix=$PREFIX -v
	make -j 4 # tired of waiting for 'make' to finish?
	sudo make install
	rm -rf *
fi

# missing here: glibc
# glibc is required in i686-pc-linux-gnu binary form
# you have to build it on an appropriate machine using:
#  cd $SRCDIR
#  wget -c http://ftp.gnu.org/gnu/glibc/glibc-2.16.0.tar.gz
#  tar -xzf glibc-2.16.0.tar.gz
#  cd $BUILDDIR
#  $SRCDIR/glibc-2.16.0/configure --enable-addons --prefix=$PREFIX/$TARGET
#  make
#  sudo make install
#  cd $PREFIX
#  tar -czf $SRC_ROOT/glibc-$TARGET-prefixed.tar.gz $TARGET

# once compiled, you can put the tarball on your phone and simply unpack:
#  cd $PREFIX
#  sudo tar -xzf $SRC_ROOT/glibc-$TARGET-prefixed.tar.gz

# update: precompiled version available
if [ -z $SKIPGLIBC ]; then
	cd $SRCDIR
	wget -c http://debian-armhf-bootstrap.googlecode.com/files/glibc-$TARGET-prefixed.tar.gz
	cd $PREFIX
	sudo tar -xzvf $SRCDIR/glibc-$TARGET-prefixed.tar.gz
	#restore folder permissions...
	find $PREFIX -type d -exec chmod 0755 {} \;
fi

# then you can proceed with building gcc as below

if [ -z $SKIPGCC ]; then
	cd $SRCDIR
	wget -c http://ftp.gnu.org/gnu/gcc/gcc-4.6.2/gcc-4.6.2.tar.gz
	tar -xzvf gcc-4.6.2.tar.gz
	cd $BUILDDIR
	$SRCDIR/gcc-4.6.2/configure --enable-languages=c,c++ \
		--with-included-gettext --enable-shared \
		--enable-threads=posix \
		--with-headers=$PREFIX/$TARGET/include/ \
		--target=$TARGET --host=$HOST --build=$BUILD \
		--prefix=$PREFIX -v
	wget -c https://github.com/downloads/debidroidcc/debidroidcc/linux-unwind.patch --no-check-certificate
	patch --ignore-whitespace $SRCDIR/gcc-4.6.2/gcc/config/i386/linux-unwind.h < linux-unwind.patch
	sudo ln -s /usr/include/linux $PREFIX/i686-pc-linux-gnu/include/linux
	sudo ln -s /usr/include/asm-generic $PREFIX/i686-pc-linux-gnu/include/asm
	sudo ln -s /usr/include/asm-generic $PREFIX/i686-pc-linux-gnu/include/asm-generic
	
	# commented out these as i find them too intrusive:
	#sudo ln -s $PREFIX/libexec/gcc/i686-pc-linux-gnu/4.6.2/cc1 /usr/bin/cc1
	#sudo ln -s $PREFIX/libexec/gcc/i686-pc-linux-gnu/4.6.2/cc1plus /usr/bin/cc1plus
	
	# also commented out these as they're not needed
	#sudo ln -s $PREFIX/bin/i686-pc-linux-gnu-gcc $PREFIX/bin/gcc
	#sudo ln -s $PREFIX/bin/i686-pc-linux-gnu-g++ $PREFIX/bin/g++
	#sudo ln -s $PREFIX/bin/gcc $PREFIX/bin/cc

	make -j 4
	sudo make install
	rm -rf *
fi
