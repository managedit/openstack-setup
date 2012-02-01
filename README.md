# OpenStack Setup Scripts

These scripts install+setup OpenStack (an all in one server, or all bar compute + compute nodes).

# Assumptions:

1. You want to use the VLAN network manager. (NOTE: The requires VLAN capable switches!)
2. You want to use multi-node networking (NOTE: This is *very* different to simply having multiple compute nodes. Read up on it.)
3. You want to use 2 network cards in every server (1 for public traffic, 1 for nova's internal traffic)
4. You are installing on 100% clean Ubuntu 11.10 servers (i.e. you have *never* attempted to install OpenStack on these servers since the last time they were wiped)

If these assumptions are not valid for your setup, these scripts will not work and have not been tested. They could be changed for others, but out of the box, that is simply what they do.

NOTE: These scripts do NOT secure your setup. eg the default RabbitMQ "guest" account is used etc. Is is **your** job to handle that kind of stuff after you have a quick and dirty, but working install done.

# All in one server (You can add more later...)

Instructions:

1. Install ubuntu 11.10
2. Setup /etc/network/interfaces (See sample below)
3. Login as root
4. Install git (apt-get install git)
5. Clone scripts (git clone https://github.com/managedit/openstack-setup.git)
6. Edit "settings" to suit.. (or better yet, create settings.local and copy the settings you want to change in there.)
7. Run: ./all-in-one.sh
8. ...
9. Profit!

## Sample /etc/network/interfaces

    auto eth0
    iface eth0 inet static
            address 192.0.2.2
            netmask 255.255.255.0
            network 192.0.2.0
            broadcast 192.0.2.255
            gateway 192.0.2.1
    
    # Bring up eth1 without an IP address (You can have one if you want, but the point here is its not needed)
    auto eth1
    iface eth1 inet manual
            up ifconfig eth1 up 

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
    sed -i 's/server ntp.ubuntu.com/server ntp.ubuntu.com\nserver 127.127.1.0\nfudge 127.127.1.0 stratum 10/g' /etc/ntp.conf  
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