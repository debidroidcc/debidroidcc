#!/bin/bash

# this must be executed as root

set -e
set -x

export HOME=/root

MYDIR=$(dirname "${BASH_SOURCE[0]}")
MYDIR=$(cd "$MYDIR"; pwd)

# build tools:
apt-get install -y build-essential sudo
# gcc build dependencies:
apt-get install -y libgmp3-dev libmpfr-dev libmpc-dev

# continue with building the stuff...
$MYDIR/build-cross-cc.sh

# check if binutils working:
/usr/local/cross-cc/i686-pc-linux-gnu/bin/ld --version

# check if gcc working:
/usr/local/cross-cc/i686-pc-linux-gnu/bin/gcc --version

