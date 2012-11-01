debidroidcc
===========

Debian with distcc for distributed cross compiling on android (sounds stupid, we know)

BusyBox
-------

Some scripts in this repo depend on BusyBox for Android, which is available in binary form here:
<https://github.com/Gnurou/busybox-android>

SuperUser (su)
--------------

To install Debian on an Android machine/phone, you must have superuser privileges.  
You can get these by installing the `su` (superuser) binary in `/system/xbin/su` and giving it modifiers `chmod 06775`.  
This is also known as 'rooting' your phone and there are many guides available on how to do this depending on your hardware.