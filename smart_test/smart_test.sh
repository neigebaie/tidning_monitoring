#!/bin/bash

# Run SMART test
smartctl -H /dev/sda1 > /var/log/smart_test.log

# My HDD is /dev/sda1 but change it according to your setup
# Use lsblk to check