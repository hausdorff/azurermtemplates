#!/bin/bash

# ---                                     ---
# --- MESOSPHERE CONFIG SCRIPT FOR CENTOS ---
# ---                                     ---

# Add the repository
rpm -Uvh http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm

# Install Mesos and ZK
yum -y install mesos marathon
yum -y install mesosphere-zookeeper

# Configure ZK
ID=1
ID=`expr "$1" + "$ID"`
echo $ID | tee /var/lib/zookeeper/myid

echo | tee -a /etc/zookeeper/conf/zoo.cfg
echo "server.1=${2}:2888:3888" | tee -a /etc/zookeeper/conf/zoo.cfg
echo "server.1=${3}:2888:3888" | tee -a /etc/zookeeper/conf/zoo.cfg
echo "server.1=${4}:2888:3888" | tee -a /etc/zookeeper/conf/zoo.cfg

# Start ZK
systemctl start zookeeper

# Mesos & Marathon configuration
echo "zk://${2}:2181,${3}:2181,${4}:2181/mesos" | tee /etc/mesos/zk
echo 2 | tee /etc/mesos-master/quorum

# Disable mesos-slave service
systemctl stop mesos-slave.service
systemctl disable mesos-slave.service

# Restart Mesos/Marathon services to bring them up at roughly the same time
service mesos-master restart
service marathon restart