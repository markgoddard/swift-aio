#!/bin/bash

sudo adduser stack --disabled-password
sudo bash -c "echo 'stack ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/devstack"
