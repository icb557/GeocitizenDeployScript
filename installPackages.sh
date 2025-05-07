#!/bin/bash

# Exit immediately on errors
set -e

# Create log directory
#mkdir -p "$HOME/Geocitizen/deployScripts/logs"

# Set log file
#LOG_FILE="$HOME/Geocitizen/deployScripts/logs/install_packages_$(date +'%Y%m%d_%H%M%S').log"

# Redirect output and error to log file
#exec > >(tee -i -a "$LOG_FILE")
#exec 2>&1

echo
echo "------------------------------------------------------------"
echo "$(date +'%Y-%m-%d %H:%M:%S') - Starting package installation"

# Update package list
echo "--- Updating package list ---"
sudo apt update

# Frontend packages
echo "--- Installing frontend packages ---"
sudo apt install -y python2 nodejs npm

# Backend packages
echo "--- Installing backend packages ---"
sudo apt install -y openjdk-8-jdk maven

# Database packages
echo "--- Installing database packages ---"
sudo apt install -y postgresql postgresql-contrib mongodb

# Tomcat installation
echo "--- Downloading and installing Apache Tomcat 9 ---"
cd /tmp
curl -O https://downloads.apache.org/tomcat/tomcat-9/v9.0.104/bin/apache-tomcat-9.0.104.tar.gz
sudo mkdir -p /usr/share/tomcat9
sudo tar xzvf apache-tomcat-9.0.104.tar.gz -C /usr/share/tomcat9 --strip-components=1

echo "--- Installation completed successfully ---"
echo "------------------------------------------------------------"

exit 0
