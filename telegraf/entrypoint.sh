#!/bin/bash

# Start cron service
cron -f &

# Start telegraf service
telegraf
