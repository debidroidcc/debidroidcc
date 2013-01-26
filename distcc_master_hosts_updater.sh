#!/bin/bash

read deviceStatus
read ip port <<< `getpeername`
sed -i "/$ip/d" ~/.distcc/hosts
if [ $deviceStatus == '0' ]; then
	echo $ip >> ~/.distcc/hosts
fi
