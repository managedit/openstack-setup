#!/bin/bash

# Settings
. settings

apt-get install -y keystone python-mysqldb mysql-server curl

# Keystone Setup
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e 'DROP DATABASE IF EXISTS keystone;'
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e 'CREATE DATABASE keystone;'

echo "$COUNT: Update keystone.conf sql connection to '$MYSQL_CONN/keystone'"
COUNT=`expr $COUNT + 1`

echo "$COUNT: Restart keystone"
COUNT=`expr $COUNT + 1`

# Keystone Data
sed -e "s,%HOST_IP%,$HOST_IP,g" keystone_data.sh.tmpl > keystone_data.sh
sed -e "s,%SERVICE_TOKEN%,$SERVICE_TOKEN,g" -i keystone_data.sh
sed -e "s,%ADMIN_PASSWORD%,$ADMIN_PASSWORD,g" -i keystone_data.sh
sed -e "s,%REGION%,$REGION,g" -i keystone_data.sh

chmod +x keystone_data.sh

echo "$COUNT: Run keystone_data.sh to load initial data"
COUNT=`expr $COUNT + 1`
