#!/bin/bash

apt-get install -y python-software-properties
apt-add-repository -y ppa:managedit/openstack
apt-get update
apt-get install -y managedit-openstack-pin
apt-get install -y ntp
apt-get install -y python-mysqldb mysql-server rabbitmq-server
sed -i 's/server ntp.ubuntu.com/server ntp.ubuntu.com n\server 127.127.1.0 n\fudge 127.127.1.0 stratum 10/g' /etc/ntp.conf
service ntp restart
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
service mysql restart

echo "\n\nAllow root remote access to MySQL! Do this in another window!"
echo "GRANT ALL PRIVILEGES ON . TO 'root'@'%' IDENTIFIED BY 'PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;\n\n"
echo "Press any key to continue"
read

./keystone.sh
sleep 15

./glance.sh
sleep 15

./nova-controller.sh
sleep 15

./nova-compute.sh
sleep 15

./dashboard.sh
