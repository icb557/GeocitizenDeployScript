#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Log directory
LOG_DIR="$HOME/deployScripts/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/full_deployment_$(date +'%Y%m%d_%H%M%S').log"

# Log all output to file and console
exec > >(tee -i -a "$LOG_FILE")
exec 2>&1

echo
echo "=================================================================================="
echo "$(date +'%Y-%m-%d %H:%M:%S')"
echo "=== Starting Full Deployment Process ==="
echo "=================================================================================="

# Set the working directory to where the scripts are located
SCRIPT_DIR="$HOME/deployScripts"
cd "$SCRIPT_DIR"

# Execute scripts in the correct order
echo "--- Running netConfig.sh ---"
#./netConfig.sh

echo "--- Running installPackages.sh ---"
./installPackages.sh

echo "--- Running clone_source_code.sh ---"
./clone_source_code.sh

echo "--- Running db_config.sh ---"
./db_config.sh

echo "--- Running backendSetup.sh ---"
./backendSetup.sh

echo "--- Running frontendSetup.sh ---"
./frontendSetup.sh

echo "--- Running tomcatSetup.sh ---"
./tomcatSetup.sh

echo "--- Running build_frontend.sh ---"
./build_frontend.sh

echo "--- Running build_backend.sh ---"
./build_backend.sh

echo
echo "=================================================================================="
echo "$(date +'%Y-%m-%d %H:%M:%S')"
echo "=== Full Deployment Completed Successfully ==="
echo "=================================================================================="

exit 0
