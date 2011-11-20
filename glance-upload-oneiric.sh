#!/bin/bash

# Import Settings
. settings

if [ ! -f "oneiric-server-cloudimg-amd64-disk1.img" ] ; then
	echo "Downloading image"
	wget http://cloud-images.ubuntu.com/oneiric/current/oneiric-server-cloudimg-amd64-disk1.img
fi

TOKEN=`./obtain-token.sh`

echo "Uploading image"
glance -A $TOKEN add name="ubuntu-oneiric" is_public=true container_format=ovf disk_format=qcow2 < oneiric-server-cloudimg-amd64-disk1.img