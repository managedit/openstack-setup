#!/bin/bash

. settings

echo "mysql-server-5.1 mysql-server/root_password password $MYSQL_ROOT_PASS" > /tmp/mysql.preseed
echo "mysql-server-5.1 mysql-server/root_password_again password $MYSQL_ROOT_PASS" >> /tmp/mysql.preseed
cat /tmp/mysql.preseed | debconf-set-selections

rm /tmp/mysql.preseed

apt-get install -y python-software-properties
apt-add-repository -y ppa:managedit/openstack
apt-get update
apt-get install -y managedit-openstack-pin
apt-get install -y ntp
apt-get install -y python-mysqldb mysql-server rabbitmq-server
sed -i 's/server ntp.ubuntu.com/server ntp.ubuntu.com\nserver 127.127.1.0\nfudge 127.127.1.0 stratum 10/g' /etc/ntp.conf
service ntp restart
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
service mysql restart

echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASS}' WITH GRANT OPTION; FLUSH PRIVILEGES;" | mysql -u root -p$MYSQL_ROOT_PASS

sleep 2

./keystone.sh
sleep 15

./glance.sh
sleep 15

./nova-controller.sh
sleep 15

./nova-compute.sh
sleep 15

./dashboard.sh
