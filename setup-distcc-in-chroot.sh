#!/bin/bash

# this must be executed as root

set -e
set -x

apt-get -y install distcc
# setup the path to point to the cross-compiler as first directory
sed -i -e 's|PATH=/usr/local/sbin|PATH=/usr/local/cross-cc/i686-pc-linux-gnu/bin:/usr/local/sbin|g' /etc/init.d/distcc
sed -i -e 's|STARTDISTCC="false"|STARTDISTCC="true"|g' /etc/default/distcc
sed -i -e 's|ALLOWEDNETS="127.0.0.1"|ALLOWEDNETS="0.0.0.0/0"|g' /etc/default/distcc
sed -i -e 's|LISTENER="127.0.0.1"|LISTENER="0.0.0.0"|g' /etc/default/distcc
sed -i -e 's|ZEROCONF="false"|ZEROCONF="true"|g' /etc/default/distcc
