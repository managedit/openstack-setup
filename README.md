# OpenStack Setup Scripts

These scripts install+setup OpenStack (an all in one server).

# All Servers

Edit "settings" to suit..

Install this PPA https://launchpad.net/~managedit/+archive/openstack

> apt-add-repository -y ppa:managedit/openstack  
> apt-get update  
> apt-get install -y managedit-openstack-pin  

On the MySQL / RabbitMQ Servers (Probably you're controller node)

> apt-get install -y python-mysqldb mysql-server rabbitmq-server

## Install Keystone

Run this, and do what it says!

> ./keystone.sh

then test with:

> ./keystone-test.sh

## Install Glance

Run this, and do what it says!

> ./glance.sh

then test with:

> ./glance-test.sh

## Install Nova

Run this, and do what it says!

> ./nova.sh

then, you guessed it, test with:

> ./nova-test.sh

## Install Dashboard

Run this, and do what it says!

> ./dashboard.sh

then test by visiting http://$HOST_IP/
