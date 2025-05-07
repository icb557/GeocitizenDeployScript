#!/bin/bash

# Exit on error
set -e

# Log file setup
#LOG_DIR="$HOME/Geocitizen/deployScripts/logs"
#mkdir -p "$LOG_DIR"
#LOG_FILE="$LOG_DIR/tomcat_setup_$(date +'%Y%m%d_%H%M%S').log"

# Redirect all output to log file and console
#exec > >(tee -i -a "$LOG_FILE")
#exec 2>&1

echo
echo "----------------------------------------------------------------------------------"
echo "$(date +'%Y-%m-%d %H:%M:%S')"
echo "=== Starting Tomcat setup ==="

# Create tomcat user
echo "--- Creating Tomcat user ---"
sudo useradd -m -U -d /usr/share/tomcat9/ -s /bin/bash -p "$(openssl passwd -1 tomcat)" tomcat

# Set ownership and permissions
echo "--- Setting permissions and ownership ---"
sudo chown -R tomcat: /usr/share/tomcat9/
sudo chmod +x /usr/share/tomcat9/bin/*.sh
sudo chmod -R o=rwx /usr/share/tomcat9/webapps/

# Configure Tomcat service
echo "--- Configuring Tomcat systemd service ---"
sudo cp auxFiles/tomcatServiceConf.txt /etc/systemd/system/tomcat.service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

# Final status check
echo "--- Checking Tomcat service status ---"
sudo systemctl status tomcat

echo "=== Tomcat setup completed successfully ==="
echo "----------------------------------------------------------------------------------"

exit 0
