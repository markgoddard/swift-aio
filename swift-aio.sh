#!/bin/bash

# Install devstack
git clone https://git.openstack.org/openstack-dev/devstack -b stable/newton
cd devstack/
cp /vagrant/local.conf local.conf
./stack.sh 
