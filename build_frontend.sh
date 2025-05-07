#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Create directory if not exist
#mkdir -p "$HOME/Geocitizen/deployScripts/logs"

# Log all output
#exec > >(tee -i -a "$HOME/Geocitizen/deployScripts/logs/build_frontend.log")
#exec 2>&1

echo
echo "----------------------------------------------------------------------------------"
echo $(date +'%Y-%m-%d %H:%M:%S')
echo "=== Starting build frontend ==="

# Build front-end
cd $HOME/Geocitizen/front-end
npm run build

echo "=== Copying front end artifact into webapp folder in backend"
# Copy artifact to webapp folder in backend
cp -rf dist/* $HOME/Geocitizen/src/main/webapp/
cd $HOME/Geocitizen/src/main/webapp/

# Fix paths in index.html
sed -i 's|/static|./static|g' index.html

echo "=== Build complete ==="
echo "----------------------------------------------------------------------------------"

exit 0
