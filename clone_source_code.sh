#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Create directory if not exist
#mkdir -p "$HOME/Geocitizen/deployScripts/logs"

# Log all output
#exec > >(tee -i -a "$HOME/Geocitizen/deployScripts/logs/clone_source_code.log")
#exec 2>&1

git clone https://github.com/icb557/Geocitizen.git $HOME/Geocitizen

exit 0
