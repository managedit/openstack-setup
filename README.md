# OpenStack Setup Scripts

These scripts install+setup OpenStack (an all in one server, or all bar compute + compute nodes).

# Do this on all servers

Edit "settings" to suit..

Install this PPA https://launchpad.net/~managedit/+archive/openstack

    apt-get install -y python-software-properties
    apt-add-repository ppa:managedit/openstack
    apt-get update
    apt-get install -y managedit-openstack-pin

Install and configure NTP

    apt-get install ntp

(Todo: Configure nodes to use controller as NTP source)

# Do this on On the MySQL / RabbitMQ / NTP Servers (Probably your controller node)

Install MySQL, RabbitMQ and ntp

    apt-get install -y python-mysqldb mysql-server rabbitmq-server
    sed -i 's/server ntp.ubuntu.com/server ntp.ubuntu.com n\server 127.127.1.0 n\fudge 127.127.1.0 stratum 10/g' /etc/ntp.conf
    service ntp restart
    sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
    service mysql restart

## Install Keystone

Run this, and do what it says!

    ./keystone.sh

then test with:

    ./keystone-test.sh

## Install Glance

Run this, and do what it says!

    ./glance.sh

then test with:

    ./glance-test.sh

## Install Nova

### Controller Node

Run this, and do what it says!

    ./nova-controller.sh

### Compute Node(s)

Run this, and do what it says!

    ./nova-compute.sh

Then test with:

    ./nova-test.sh

## Install Dashboard

Run this, and do what it says!

    ./dashboard.sh

then test by visiting http://$HOST_IP/
