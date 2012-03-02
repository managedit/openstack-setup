#!/bin/bash

# Import Settings
. settings

if [ ! -f "precise-server-cloudimg-amd64-disk1.img" ] ; then
	echo "Downloading image"
	wget http://cloud-images.ubuntu.com/precise/current/precise-server-cloudimg-amd64-disk1.img
fi

TOKEN=`./obtain-token.sh`

echo "Uploading image"
glance -A $TOKEN add name="ubuntu-precise" is_public=true container_format=ovf disk_format=qcow2 < precise-server-cloudimg-amd64-disk1.img
