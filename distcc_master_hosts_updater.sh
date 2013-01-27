#!/bin/bash

# deviceStatus E {0,1}
# STATUS_PLUGGED = 0
# STATUS_UNPLUGGED = 1
read deviceStatus

# read ip and port from remote peer connected to STDIN
read ip port <<< `getpeername`

# remove duplicates
sed -i "/$ip/Id" ~/.distcc/hosts

if [ $deviceStatus == '0' ]; then
	echo $ip >> ~/.distcc/hosts
fi
