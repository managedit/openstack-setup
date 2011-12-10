#!/bin/bash

# Settings
. settings

apt-get install -y nova-api nova-compute nova-network python-keystone python-mysqldb mysql-client curl

# Nova Setup
sed -e "s,999888777666,$SERVICE_TOKEN,g" api-paste-keystone.ini.tmpl > api-paste-keystone.ini

# Nova Config
sed -e "s,%HOST_IP%,$HOST_IP,g" nova.conf.tmpl > nova.conf
sed -e "s,%PUBLIC_INTERFACE%,$PUBLIC_INTERFACE,g" -i nova.conf
sed -e "s,%VLAN_INTERFACE%,$VLAN_INTERFACE,g" -i nova.conf
sed -e "s,%REGION%,$REGION,g" -i nova.conf
sed -e "s,%MYSQL_HOST%,$MYSQL_HOST,g" -i nova.conf
sed -e "s,%MYSQL_NOVA_PASS%,$MYSQL_NOVA_PASS,g" -i nova.conf
sed -e "s,%FIXED_RANGE_MASK%,$FIXED_RANGE_MASK,g" -i nova.conf
sed -e "s,%FIXED_RANGE_NET%,$FIXED_RANGE_NET,g" -i nova.conf
sed -e "s,%FIXED_RANGE%,$FIXED_RANGE,g" -i nova.conf

# Fix dnsmasq
sed -e "s,ENABLED=1,ENABLED=0,g" -i /etc/default/dnsmasq

killall dnsmasq
sleep 1
killall -9 dnsmasq

cp nova.conf api-paste-keystone.ini /etc/nova/
chown nova:nova /etc/nova/nova.conf /etc/nova/api-paste-keystone.ini

service nova-api restart
service nova-network restart
service nova-compute restart

echo "*** MANUALLY RESTART ALL NOVA SERVICES ***"
