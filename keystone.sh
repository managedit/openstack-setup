#!/bin/bash

# Settings
. settings

apt-get install -y keystone python-mysqldb mysql-client curl

# Keystone Setup
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_ROOT_PASS -e 'DROP DATABASE IF EXISTS keystone;'
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_ROOT_PASS -e 'CREATE DATABASE keystone;'

echo "GRANT ALL ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$MYSQL_KEYSTONE_PASS';" | mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_ROOT_PASS

sed -e "s,%MYSQL_HOST%,$MYSQL_HOST,g" keystone.conf.tmpl > keystone.conf
sed -e "s,%MYSQL_KEYSTONE_PASS%,$MYSQL_KEYSTONE_PASS,g" -i keystone.conf

cp keystone.conf /etc/keystone/keystone.conf
chown keystone /etc/keystone/keystone.conf

service keystone restart

sleep 5

# Keystone Data
sed -e "s,%HOST_IP%,$HOST_IP,g" keystone_data.sh.tmpl > keystone_data.sh
sed -e "s,%SERVICE_TOKEN%,$SERVICE_TOKEN,g" -i keystone_data.sh
sed -e "s,%ADMIN_PASSWORD%,$ADMIN_PASSWORD,g" -i keystone_data.sh
sed -e "s,%REGION%,$REGION,g" -i keystone_data.sh

chmod +x keystone_data.sh

./keystone_data.sh
