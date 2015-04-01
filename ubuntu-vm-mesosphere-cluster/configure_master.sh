#!/bin/bash

# Add mesosphere repository to hosts, so we can install it. Basically involves:
#   1. Downloading the proj key from Ubuntu servers
#   2. Splicing the correct URL for this specific Ubuntu version
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list

# Install Mesosphere
sudo apt-get -y update
sudo apt-get install mesosphere

# Set up ZK connection info
# TODO: get a random number of arguments, put them into a single config string
#       and pipe them to the /etc/mesos/zk file!
sudo echo "zk://192.0.2.1:2181,192.0.2.2:2181,192.0.2.3:2181/mesos" > /etc/mesos/zk

# Master ZK configuration
sudo echo $MASTER_ID > /etc/zookeeper/conf/myid