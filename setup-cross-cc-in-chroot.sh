#!/bin/bash

# this must be executed as root

set -e
set -x

MYDIR=$(dirname "${BASH_SOURCE[0]}")
MYDIR=$(cd "$MYDIR"; pwd)

# build tools:
apt-get install -y build-essential
# gcc build dependencies:
apt-get install -y libgmp3-dev libmpfr-dev libmpc-dev

# continue with building the stuff...
source $MYDIR/build-cross-cc.sh
