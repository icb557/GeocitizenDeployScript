#!/bin/bash

# Exit immediately on any error
set -e

# Create logs directory if it doesn't exist
#LOG_DIR="$HOME/Geocitizen/deployScripts/logs"
#mkdir -p "$LOG_DIR"

# Log output to file and terminal
#exec > >(tee -i -a "$LOG_DIR/frontend_setup_$(date +'%Y%m%d_%H%M%S').log")
#exec 2>&1

echo
echo "----------------------------------------------------------------------------------"
echo "$(date +'%Y-%m-%d %H:%M:%S')"
echo "=== Starting front-end setup ==="

FRONTEND_DIR="$HOME/Geocitizen/front-end"
cd "$FRONTEND_DIR"

echo "--- Fixing vue-material dependency version ---"
sed -i 's/"vue-material": "\^1\.0\.0-beta-7"/"vue-material": "1.0.0-beta-11"/' package.json

echo "--- Setting domain to geocitizen.com ---"
sed -i "s/host: 'localhost'/host: 'geocitizen.com'/" config/index.js
sed -i "s|backEndUrl = 'http://localhost:8080/citizen/'|backEndUrl = 'http://geocitizen.com:8080/citizen/'|" src/main.js

echo "--- Installing npm dependencies ---"
sudo npm install

echo "=== Front-end setup completed successfully ==="
echo "----------------------------------------------------------------------------------"

exit 0
