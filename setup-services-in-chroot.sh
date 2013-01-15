#!/bin/bash

# this must be executed as root

set -e
set -x

apt-get -y install sysklogd dbus avahi-daemon
usermod -a -G inet avahi
