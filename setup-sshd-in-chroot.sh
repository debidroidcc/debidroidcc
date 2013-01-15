#!/bin/bash

# this must be executed as root

set -e
set -x

apt-get -y install openssh-server
sed -i -e 's/Port 22/Port 222/g' /etc/ssh/sshd_config

# starting is finally done by the after-reboot... scripts
# /etc/init.d/ssh restart
