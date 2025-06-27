#!/bin/sh

# Install Telegraf if not present
if ! command -v telegraf >/dev/null 2>&1; then
  echo "Installing Telegraf..."
  if [ -f /etc/debian_version ]; then
    sudo apt update
    sudo apt install -y telegraf
  else
    echo "Unsupported OS. Please install Telegraf manually."
    exit 1
  fi
fi

# Copy configuration
echo "Copying telegraf.conf to /etc/telegraf/telegraf.conf"
sudo cp ./telegraf.conf /etc/telegraf/telegraf.conf

# Enable and start Telegraf service
echo "Enabling and starting Telegraf service..."
sudo systemctl enable telegraf
sudo systemctl restart telegraf

echo "Telegraf is now running with your configuration."