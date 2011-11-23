# OpenStack Setup Scripts

These scripts install+setup OpenStack (an all in one server, or all bar compute + compute nodes).

**This only suports VLAN networking where each server has 2x network cards**  
It could be changed for others, but out of the box, thats what it does.

NOTE: These scripts do NOT secure your setup. Every service connects to MySQL as root, The default RabbitMQ account is used etc. Is is **your** job to handle that kind of stuff after you have a quick and dirty, but working install done.


# All in one server (You can add more later...)

Prep:

1. Install ubuntu 11.10
2. Login as root
3. Install git (apt-get install git)
4. Clone scripts (git clone https://github.com/managedit/openstack-setup.git)
5. Edit "settings" to suit.. (or create settings.local with overrides)
6. Run: ./all-in-one.sh
7. ...
8. Profit!

# Multiple Servers

## Do this on all servers

Edit "settings" to suit.. (or create settings.local with overrides)

Install this PPA https://launchpad.net/~managedit/+archive/openstack

    apt-get install -y python-software-properties  
    apt-add-repository -y ppa:managedit/openstack  
    apt-get update  
    apt-get install -y managedit-openstack-pin  

Install and configure NTP

    apt-get install -y ntp

(Todo: Configure nodes to use controller as NTP source)

## Do this on On the MySQL / RabbitMQ / NTP Servers (Probably your controller node)

Install MySQL, RabbitMQ and ntp

    apt-get install -y python-mysqldb mysql-server rabbitmq-server  
    sed -i 's/server ntp.ubuntu.com/server ntp.ubuntu.com n\server 127.127.1.0 n\fudge 127.127.1.0 stratum 10/g' /etc/ntp.conf  
    service ntp restart  
    sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf  
    service mysql restart  

Grant root remote access to MySQL

    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;

### Install Keystone

Run this:

    ./keystone.sh

then test with:

    ./keystone-test.sh

### Install Glance

Run this:

    ./glance.sh

then test with:

    ./glance-test.sh

### Install Nova

#### Controller Node

Run this:

    ./nova-controller.sh

#### Compute Node(s)

Run this:

    ./nova-compute.sh

Then test with:

    ./nova-test.sh

### Install Dashboard

Run this:

    ./dashboard.sh

then test by visiting http://$HOST_IP/