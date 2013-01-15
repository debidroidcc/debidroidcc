#!/bin/bash

# execute this as root

#sudo /etc/init.d/ddclient start # this dyndns client has its flaws
/etc/init.d/sysklogd start
nohup inadyn > /dev/null & # inadyn debian package has no start script in /etc/init.d
/etc/init.d/ssh start
/etc/init.d/dbus start
/etc/init.d/avahi-daemon start
/etc/init.d/distcc start
