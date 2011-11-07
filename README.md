# OpenStack Setup Scripts

These scripts install+setup OpenStack (an all in one server).

# All Services

Install this PPA https://launchpad.net/~managedit/+archive/openstack

> apt-add-repository -y ppa:managedit/openstack  
> apt-get update  
> apt-get install -y managedit-openstack-pin  
> apt-get install -y python-mysqldb mysql-server

Edit "settings" to suit..

# Keystone

Run this, and do what it says!

> ./keystone.sh

then test with:

> ./keystone-test.sh

# Glance

Run this, and do what it says!

> ./glance.sh

then test with:

> ./glance-test.sh

# Nova

Run this, and do what it says!

> ./nova.sh

then, you guessed it, test with:

> ./nova-test.sh

# Dashboard

Run this, and do what it says!

> ./dashboard.sh

then test by visiting http://$HOST_IP/
