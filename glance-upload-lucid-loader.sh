#!/bin/bash

# Import Settings
. settings

if [ ! -f "lucid-server-cloudimg-amd64.tar.gz" ] ; then
	echo "Downloading image"
	wget http://cloud-images.ubuntu.com/lucid/current/lucid-server-cloudimg-amd64.tar.gz
fi

if [ ! -f "lucid-server-cloudimg-amd64.img" ] ; then
        echo "Extracting image"
	tar xfzv lucid-server-cloudimg-amd64.tar.gz
fi

TOKEN=`./obtain-token.sh`

KERNEL_ID=`glance index -A $TOKEN --limit=99999999999 | grep loader-kernel | cut -d" " -f1`
RAMDISK_ID=`glance index -A $TOKEN --limit=99999999999 | grep loader-ramdisk | cut -d" " -f1`

echo "Uploading image"
glance -A $TOKEN add name="ubuntu-lucid" is_public=true container_format=ami disk_format=ami kernel_id=$KERNEL_ID ramdisk_id=$RAMDISK_ID < lucid-server-cloudimg-amd64.img
