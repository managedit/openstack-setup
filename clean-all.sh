#!/bin/bash

./clean.sh

PACKAGES=`dpkg -l | grep -E "(openstack|nova|keystone|glance|swift)" | grep -v "kohana" | cut -d" " -f3 | tr "\\n" " "`

apt-get purge $PACKAGES

rm -rf /etc/nova /etc/glance /etc/keystone /etc/swift /etc/openstack-dashboard
rm -rf /var/lib/nova /var/lib/glance /var/lib/keystone /var/lib/swift /var/lib/openstack-dashboard
