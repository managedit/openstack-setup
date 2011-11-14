#!/bin/bash

# Settings
. settings

apt-get install -y openstack-dashboard

# Dashboard Setup

mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e 'DROP DATABASE IF EXISTS horizon;'
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e 'CREATE DATABASE horizon;'

sed -e "s,999888777666,$SERVICE_TOKEN,g" local_settings.py.tmpl > local_settings.py
sed -e "s,%MYSQL_HOST%,$MYSQL_HOST,g" -i local_settings.py
sed -e "s,%MYSQL_USER%,$MYSQL_USER,g" -i local_settings.py
sed -e "s,%MYSQL_PASS%,$MYSQL_PASS,g" -i local_settings.py

echo "$COUNT: Copy local_settings.py to /etc/openstack-dashboard/local_settings.py"
COUNT=`expr $COUNT + 1`

echo "$COUNT: Run /usr/share/openstack-dashboard/dashboard/manage.py syncdb"
COUNT=`expr $COUNT + 1`
