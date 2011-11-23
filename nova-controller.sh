#!/bin/bash

# Settings
. settings

apt-get install -y nova-api nova-scheduler nova-objectstore nova-vncproxy nova-ajax-console-proxy openstackx python-mysqldb mysql-client curl

# Nova Setup
sed -e "s,999888777666,$SERVICE_TOKEN,g" api-paste-keystone.ini.tmpl > api-paste-keystone.ini

mysql -h $MYSQL_HOST -u root -p$MYSQL_ROOT_PASS -e 'DROP DATABASE IF EXISTS nova;'
mysql -h $MYSQL_HOST -u root -p$MYSQL_ROOT_PASS -e 'CREATE DATABASE nova;'

echo "GRANT ALL ON nova.* TO 'nova'@'%' IDENTIFIED BY '$MYSQL_NOVA_PASS'; FLUSH PRIVILEGES;" | mysql -h $MYSQL_HOST -u root -p$MYSQL_ROOT_PASS

# Nova Config
sed -e "s,%HOST_IP%,$HOST_IP,g" nova.conf.tmpl > nova.conf
sed -e "s,%VLAN_INTERFACE%,$VLAN_INTERFACE,g" -i nova.conf
sed -e "s,%REGION%,$REGION,g" -i nova.conf
sed -e "s,%MYSQL_HOST%,$MYSQL_HOST,g" -i nova.conf
sed -e "s,%MYSQL_NOVA_PASS%,$MYSQL_NOVA_PASS,g" -i nova.conf
sed -e "s,%FIXED_RANGE_MASK%,$FIXED_RANGE_MASK,g" -i nova.conf
sed -e "s,%FIXED_RANGE_NET%,$FIXED_RANGE_NET,g" -i nova.conf
sed -e "s,%FIXED_RANGE%,$FIXED_RANGE,g" -i nova.conf

cp nova.conf api-paste-keystone.ini /etc/nova/

chown nova:nova /etc/nova/nova.conf /etc/nova/api-paste-keystone.ini

service nova-api restart

sleep 5

nova-manage db sync

sleep 5

service nova-api restart
service nova-scheduler restart
service nova-objectstore restart
service nova-vncproxy restart
service nova-ajax-console-proxy restart

nova-manage network create --multi_host T --network_size 16 --num_networks 16 --bridge_interface $VLAN_INTERFACE --fixed_range_v4 $FIXED_RANGE --label internal
nova-manage floating create --ip_range=$FLOATING_RANGE
