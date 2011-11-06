#!/bin/bash

# Settings
. settings

#apt-get install -y openstack-dashboard

# Dashboard Setup

mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e 'DROP DATABASE IF EXISTS dashboard;'
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e 'CREATE DATABASE dashboard;'

sed -e "s,999888777666,$SERVICE_TOKEN,g" local_settings.py.tmpl > local_settings.py

echo "$COUNT: Copy local_settings.py to /etc/openstack-dashboard/local/local_settings.py"
COUNT=`expr $COUNT + 1`
