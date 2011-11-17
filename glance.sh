#!/bin/bash

# Settings
. settings

apt-get install -y glance python-mysqldb mysql-client curl python-httplib2

# Glance Setup
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e 'DROP DATABASE IF EXISTS glance;'
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e 'CREATE DATABASE glance;'

sed -e "s,%SERVICE_TOKEN%,$SERVICE_TOKEN,g" glance-registry.conf.tmpl > glance-registry.conf
sed -e "s,%MYSQL_CONN%,$MYSQL_CONN,g" -i glance-registry.conf
sed -e "s,%SERVICE_TOKEN%,$SERVICE_TOKEN,g" glance-api.conf.tmpl > glance-api.conf

cp glance-registry.conf glance-api.conf /etc/glance/

chown glance:glance /etc/glance/glance-registry.conf
chown glance:glance /etc/glance/glance-api.conf

service glance-api restart
service glance-registery restart

glance-manage db_sync

service glance-api restart
service glance-registery restart

./glance-upload-oneiric.sh
./glance-upload-lucid.sh


