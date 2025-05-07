#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Create logs directory if not exists
#mkdir -p "$HOME/Geocitizen/deployScripts/logs"

# Log all output and errors to a log file
#exec > >(tee -i -a "$HOME/Geocitizen/deployScripts/logs/backend_setup_$(date +'%Y%m%d_%H%M%S').log")
#exec 2>&1

echo
echo "----------------------------------------------------------------------------------"
echo "$(date +'%Y-%m-%d %H:%M:%S')"
echo "=== Starting backend setup ==="

cd ~/Geocitizen/

echo "--- Updating pom.xml ---"
sed -i \
  -e '/<repositories>/,/<\/repositories>/c\
<repository>\
    <id>central</id>\
    <url>https://repo.maven.apache.org/maven2</url>\
    <snapshots>\
        <enabled>false</enabled>\
    </snapshots>\
</repository>' \
  -e '/<distributionManagement>/,/<\/distributionManagement>/d' \
  -e 's/<artifactId>servlet-api<\/artifactId>/<artifactId>javax.servlet-api<\/artifactId>/' \
  -e 's/<springframework\.social\.facebook\.version>3\.0\.0\.M3<\/springframework\.social\.facebook\.version>/<springframework.social.facebook.version>2.0.3.RELEASE<\/springframework.social.facebook.version>/' \
  pom.xml

echo "--- Updating application.properties ---"
sed -i \
  -e "s|^front\.url=http://localhost:8080/citizen/#|front.url=http://geocitizen.com:8080/citizen/#|" \
  -e "s|^front-end\.url=http://localhost:8080/citizen/|front-end.url=http://geocitizen.com:8080/citizen/|" \
  -e "s|^email\.username=ssgeocitizen@gmail.com|email.username=cortesbuitragoisac@gmail.com|" \
  -e "s|^email\.password=softserve|email.password=ylsh ajnb hzaq ildt|" \
  -e "s|^google\.appKey=.*|google.appKey=740741452799-9tg0v0kjjlnvgb5f311pc5c81t48as68.apps.googleusercontent.com|" \
  -e "s|^google\.appSecret=.*|google.appSecret=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|" \
  src/main/resources/application.properties

echo "=== Backend setup completed successfully ==="
echo "----------------------------------------------------------------------------------"

exit 0
