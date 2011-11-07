#!/bin/bash

# Settings
. settings

apt-get install -y nova-api nova-scheduler nova-compute nova-network nova-volume nova-objectstore python-mysqldb mysql-server curl rabbitmq-server dnsmasq bridge-utils

# Nova Setup
sed -e "s,999888777666,$SERVICE_TOKEN,g" api-paste-keystone.ini.tmpl > api-paste-keystone.ini

mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e 'DROP DATABASE IF EXISTS nova;'
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e 'CREATE DATABASE nova;'

echo "$COUNT: Update nova.conf sql connection to '$MYSQL_CONN/nova'"
COUNT=`expr $COUNT + 1`

echo "$COUNT: Copy api-paste-keystone.ini to /etc/nova and chown nova:nova /etc/nova/api-paste-keystone.ini"
COUNT=`expr $COUNT + 1`

echo "$COUNT: Set nova to use keystonei by adding '--api_paste_config=api-paste-keystone.ini' to /etc/nova/nova.conf"
COUNT=`expr $COUNT + 1`

echo "$COUNT: Restart all nova services"
COUNT=`expr $COUNT + 1`

echo "$COUNT: Run nova-manage db sync"
COUNT=`expr $COUNT + 1`

echo "$COUNT: Run nova-manage network create --multi_host T --network_size 16 --num_networks 16 --bridge_interface $BRIDGE_INTERFACE --fixed_range_v4 172.16.0.0/12 --label internal"
COUNT=`expr $COUNT + 1`

echo "(this is for VLAN networking .. go read the OS docs for other network types!)"

