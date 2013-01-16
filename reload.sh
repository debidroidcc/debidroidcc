#!/bin/bash

# this must be executed as root

set -e
set -x

MYDIR=$(dirname "${BASH_SOURCE[0]}")
MYDIR=$(cd "$MYDIR"; pwd)

cd "$MYDIR/.."

wget --no-check-certificate -O debidroidcc.zip https://github.com/debidroidcc/debidroidcc/archive/master.zip
unzip -o debidroidcc.zip
