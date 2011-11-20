#!/bin/bash

# Import Settings
. settings

if [ ! -f "ttylinux-uec-amd64-12.1_2.6.35-22_1.tar.gz" ] ; then
	echo "Downloading image"
	wget http://smoser.brickies.net/ubuntu/ttylinux-uec/ttylinux-uec-amd64-12.1_2.6.35-22_1.tar.gz
fi

if [ ! -f "ttylinux-uec-amd64-12.1_2.6.35-22_1.img" ] ; then
        echo "Extracting image"
	tar xfzv ttylinux-uec-amd64-12.1_2.6.35-22_1.tar.gz
fi

TOKEN=`./obtain-token.sh`

echo "Uploading kernel"
RVAL=`glance -A $TOKEN add name="ttylinux-kernel" is_public=true container_format=aki disk_format=aki < ttylinux-uec-amd64-12.1_2.6.35-22_1-vmlinuz`
KERNEL_ID=`echo $RVAL | cut -d":" -f2 | tr -d " "`

echo "Uploading ramdisk"
RVAL=`glance -A $TOKEN add name="ttylinux-ramdisk" is_public=true container_format=ari disk_format=ari < ttylinux-uec-amd64-12.1_2.6.35-22_1-initrd`
RAMDISK_ID=`echo $RVAL | cut -d":" -f2 | tr -d " "`

echo "Uploading image"
glance -A $TOKEN add name="ttylinux" is_public=true container_format=ami disk_format=ami kernel_id=$KERNEL_ID ramdisk_id=$RAMDISK_ID < ttylinux-uec-amd64-12.1_2.6.35-22_1.img
