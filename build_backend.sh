#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Create directory if not exist
#mkdir -p "$HOME/Geocitizen/deployScripts/logs"

# Log all output
#exec > >(tee -i -a "$HOME/Geocitizen/deployScripts/logs/build_backend.log")
#exec 2>&1

echo
echo "----------------------------------------------------------------------------------"
echo $(date +'%Y-%m-%d %H:%M:%S')
echo "=== Starting build backend ==="

# Build back end
cd $HOME/Geocitizen
mvn clean install

# Ensure access to tomcat webapps
sudo chmod -R u=rwx,g=rwx,o=rwx /usr/share/tomcat9/webapps
find $HOME/Geocitizen/target -type f -name "*.war" -exec chmod +rwx {} \;

# Upload artifact to tomcat server
sudo cp -f $HOME/Geocitizen/target/citizen.war /usr/share/tomcat9/webapps/

# Ensure permissions to .war
sudo chown -R tomcat: /usr/share/tomcat9/webapps/citizen.war
sudo chmod u+rwx /usr/share/tomcat9/webapps/citizen.war

sudo systemctl restart tomcat
sudo systemctl status tomcat


echo "=== Build complete ==="
echo "----------------------------------------------------------------------------------"

exit 0
