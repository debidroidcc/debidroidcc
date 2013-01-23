#!/system/bin/sh

cd ..
busybox=/system/xbin/busybox
$busybox wget -O debidroidcc.zip http://nodeload.github.com/debidroidcc/debidroidcc/zip/master
$busybox unzip -o debidroidcc.zip
