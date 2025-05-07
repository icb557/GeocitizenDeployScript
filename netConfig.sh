#!/bin/bash

# Exit on any error
set -e

# Create log directory
#mkdir -p "$HOME/Geocitizen/deployScripts/logs"

# Setup logging
#LOG_FILE="$HOME/Geocitizen/deployScripts/logs/net_config_$(date +'%Y%m%d_%H%M%S').log"
#exec > >(tee -i -a "$LOG_FILE")
#exec 2>&1

echo
echo "----------------------------------------------------------------------------------"
echo "$(date +'%Y-%m-%d %H:%M:%S')"
echo "=== Starting network configuration script ==="

# Check for required permissions
if [[ $EUID -ne 0 ]]; then
  echo "ERROR: This script must be run as root."
  exit 1
fi

# Network interfaces configuration
echo "--- Configuring network interfaces ---"
cat ./auxFiles/netConfig.yaml > /etc/netplan/00-installer-config.yaml
netplan apply
echo "Network interfaces configured successfully."

# Add domain name to /etc/hosts
echo "--- Updating /etc/hosts with geocitizen.com domain ---"
new_line="172.16.0.11 geocitizen.com"
hosts_file="/etc/hosts"
tmp_file=$(mktemp)
last_ipv4_line=0
line_number=0

while IFS= read -r line; do
  ((line_number++))
  echo "$line" >> "$tmp_file"
  if [[ $line =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+ ]]; then
    last_ipv4_line=$line_number
  fi
done < "$hosts_file"

awk -v insert_line="$new_line" -v insert_after="$last_ipv4_line" '{
  print
  if (NR == insert_after) {
    print insert_line
  }
}' "$tmp_file" > "${tmp_file}.new"

cp "${tmp_file}.new" "$hosts_file"
rm "$tmp_file" "${tmp_file}.new"

echo "Domain name created successfully."
echo "=== Network configuration completed successfully ==="
echo "----------------------------------------------------------------------------------"

exit 0
