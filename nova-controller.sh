#!/bin/bash

# Settings
. settings

apt-get install -y nova-api nova-scheduler nova-objectstore nova-vncproxy nova-ajax-console-proxy python-mysqldb mysql-client curl

# Nova Setup
sed -e "s,999888777666,$SERVICE_TOKEN,g" api-paste-keystone.ini.tmpl > api-paste-keystone.ini

mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e 'DROP DATABASE IF EXISTS nova;'
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e 'CREATE DATABASE nova;'

# Nova Config
sed -e "s,%HOST_IP%,$HOST_IP,g" nova.conf.tmpl > nova.conf
sed -e "s,%VLAN_INTERFACE%,$VLAN_INTERFACE,g" -i nova.conf
sed -e "s,%REGION%,$REGION,g" -i nova.conf
sed -e "s,%MYSQL_CONN%,$MYSQL_CONN,g" -i nova.conf

cp nova.conf api-paste-keystone.ini /etc/nova/

chown nova:nova /etc/nova/nova.conf /etc/nova/api-paste-keystone.ini

service nova-api restart

nova-manage db sync

service nova-api restart
service nova-scheduler restart
service nova-objectstore restart
service nova-vncproxy restart
service nova-ajax-console-proxy restart

echo "$COUNT: Run nova-manage network create --multi_host T --network_size 16 --num_networks 16 --bridge_interface $VLAN_INTERFACE --fixed_range_v4 172.16.0.0/12 --label internal"
COUNT=`expr $COUNT + 1`

echo "(this is for VLAN networking .. go read the OS docs for other network types and dont forget to update /etc/nova/nova.conf!)"
