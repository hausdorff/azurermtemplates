#!/bin/bash

# Add the repository
echo "---                                         ---"
echo "--- Installing Mesos and ZooKeeper packages ---"
echo "---                                         ---"
rpm -Uvh http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm

# Install Mesos
yum -y install mesos

# Configure ZK
echo "---                       ---"
echo "--- Configuring ZooKeeper ---"
echo "---                       ---"
echo "zk://${2}:2181,${3}:2181,${4}:2181/mesos" | tee /etc/mesos/zk

# Disable the Mesos master services
echo "---                                ---"
echo "--- Stopping Mesos master services ---"
echo "---                                ---"
systemctl stop mesos-master.service
systemctl disable mesos-master.service

# Start the Mesos slave services
echo "---                               ---"
echo "--- Starting Mesos slave services ---"
echo "---                               ---"
service mesos-slave restart