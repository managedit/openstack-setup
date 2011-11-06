#!/bin/bash

# Settings
. settings

apt-get install -y glance python-mysqldb mysql-server curl

# Glance Setup
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e 'DROP DATABASE IF EXISTS glance;'
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e 'CREATE DATABASE glance;'

sed -e "s,%SERVICE_TOKEN%,$SERVICE_TOKEN,g" glance-registry.conf.tmpl > glance-registry.conf
sed -e "s,%MYSQL_CONN%,$MYSQL_CONN,g" -i glance-registry.conf
sed -e "s,%SERVICE_TOKEN%,$SERVICE_TOKEN,g" glance-api.conf.tmpl > glance-api.conf

echo "$COUNT: Copy glance-registry.conf to /etc/glance/ (and chown glance:glance it)'"
COUNT=`expr $COUNT + 1`

echo "$COUNT: Copy glance-api.conf to /etc/glance/ (and chown glance:glance it)'"
COUNT=`expr $COUNT + 1`

echo "$COUNT: Restart glance-api and glance-registery"
COUNT=`expr $COUNT + 1`

echo "$COUNT: Run glance-upload-oneiric.sh"
COUNT=`expr $COUNT + 1`

echo "$COUNT: Run glance-upload-lucid.sh"
COUNT=`expr $COUNT + 1`

