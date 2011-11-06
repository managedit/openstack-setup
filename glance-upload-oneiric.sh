#!/bin/bash

# Import Settings
. settings

if [ ! -f "oneiric-server-cloudimg-amd64.tar.gz" ] ; then
	echo "Downloading image"
	wget http://cloud-images.ubuntu.com/oneiric/current/oneiric-server-cloudimg-amd64.tar.gz
fi

if [ ! -f "oneiric-server-cloudimg-amd64.im"g ] ; then
        echo "Extracting image"
	tar xfzv oneiric-server-cloudimg-amd64.tar.gz
fi

TOKEN=`./obtain-token.sh`
echo "Uploading kernel"
glance -A $TOKEN add name="ubuntu-oneiric-kernel" is_public=true container_format=aki disk_format=aki < oneiric-server-cloudimg-amd64-vmlinuz-virtual

echo "Uploading image"
glance -A $TOKEN add name="ubuntu-oneiric" is_public=true container_format=ami kernel_id=1 disk_format=ami < oneiric-server-cloudimg-amd64.img
