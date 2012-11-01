#!/bin/bash

# execute on a debian machine (may be x86, too)

sudo apt-get install debootstrap
sudo debootstrap --arch=armhf --variant=minbase --foreign sid ./debian http://ftp.us.debian.org/debian
tar -czf debian_bootstrap.tar.gz ./debian
