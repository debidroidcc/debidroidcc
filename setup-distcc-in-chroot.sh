#!/bin/bash

# this must be executed as root

set -e
set -x

apt-get -y install distcc
# setup the path to point to the cross-compiler as first directory
sed -i -e 's|PATH=|PATH=/usr/local/cross-cc/i686-pc-linux-gnu/bin:|g' /etc/init.d/distcc
