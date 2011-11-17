#!/bin/bash

# Settings
. settings

apt-get install -y nova-api nova-scheduler nova-volume nova-objectstore python-mysqldb mysql-client curl

# Nova Setup
sed -e "s,999888777666,$SERVICE_TOKEN,g" api-paste-keystone.ini.tmpl > api-paste-keystone.ini

mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e 'DROP DATABASE IF EXISTS nova;'
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e 'CREATE DATABASE nova;'

# Nova Config
sed -e "s,%HOST_IP%,$HOST_IP,g" nova.conf.tmpl > nova.conf
sed -e "s,%VLAN_INTERFACE%,$VLAN_INTERFACE,g" -i nova.conf
sed -e "s,%REGION%,$REGION,g" -i nova.conf
sed -e "s,%MYSQL_CONN%,$MYSQL_CONN,g" -i nova.conf

echo "$COUNT: Copy nova.conf to /etc/nova and chown nova:nova /etc/nova/nova.conf"
COUNT=`expr $COUNT + 1`

echo "$COUNT: Copy api-paste-keystone.ini to /etc/nova and chown nova:nova /etc/nova/api-paste-keystone.ini"
COUNT=`expr $COUNT + 1`

echo "$COUNT: Run nova-manage db sync"
COUNT=`expr $COUNT + 1`

echo "$COUNT: Restart all nova services"
COUNT=`expr $COUNT + 1`

echo "$COUNT: Run nova-manage network create --multi_host T --network_size 16 --num_networks 16 --bridge_interface $VLAN_INTERFACE --fixed_range_v4 172.16.0.0/12 --label internal"
COUNT=`expr $COUNT + 1`

echo "(this is for VLAN networking .. go read the OS docs for other network types and dont forget to update /etc/nova/nova.conf!)"
