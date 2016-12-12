#!/bin/bash

# Install devstack
git clone https://git.openstack.org/openstack-dev/devstack -b stable/newton
cd devstack/
cp /vagrant/local.conf local.conf
./stack.sh 

# Check byte ranges
source openrc 
swift list
swift upload test-container README.md 
swift list
swift list test-container
swift download test-container README.md -o - -H 'Range: bytes=2-10,-5' --ignore-checksum
