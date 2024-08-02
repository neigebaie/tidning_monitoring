#!/bin/bash

TEST_TYPE=$1

# My HDD is $DRIVE but change it according to your setup
# Use lsblk to check
DRIVE=/dev/sda

if [ "$TEST_TYPE" == "short" ]; then
  # Start a short SMART test
  smartctl -t short $DRIVE
  # Sleep for one hour (300 seconds)
  sleep 3600
elif [ "$TEST_TYPE" == "long" ]; then
  # Start a long SMART test
  smartctl -t long $DRIVE
  # Sleep for six hours (21600 seconds)
  sleep 21600
else
  echo "Invalid test type. Use 'short' or 'long'."
  exit 1
fi

# Check the self-test log and export to a log file
smartctl -l selftest $DRIVE > /var/log/smart_selftest.log

# Check the health status and export to a log file
smartctl -H $DRIVE > /var/log/smart_health.log