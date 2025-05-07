#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Create directory if not exist
#mkdir -p "$HOME/Geocitizen/deployScripts/logs"

# Log all output
#exec > >(tee -i -a "$HOME/Geocitizen/deployScripts/logs/db_setup.log")
#exec 2>&1

echo
echo "----------------------------------------------------------------------------------"
echo $(date +'%Y-%m-%d %H:%M:%S')
echo "=== Starting database setup ==="

# Check required environment variables
if [[ -z "$PG_USER" || -z "$PG_PASSWORD" || -z "$PG_DB" || -z "$CHAT_DB" ]]; then
  echo "ERROR: One or more required environment variables are missing."
  echo "Please set PG_USER, PG_PASSWORD, PG_DB, and CHAT_DB."
  exit 1
fi

# Update package list
echo "--- Updating package list ---"
sudo apt update

# Install PostgreSQL
echo "--- Installing PostgreSQL ---"
sudo apt install -y postgresql postgresql-contrib

# Start PostgreSQL service
echo "--- Enabling and starting PostgreSQL service ---"
sudo systemctl enable postgresql
sudo systemctl start postgresql

# Create PostgreSQL user and database
echo "--- Creating PostgreSQL user and database ---"
sudo -u postgres psql -c "
-- Create user
DO \$\$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_user WHERE usename = '${PG_USER}'
   ) THEN
      EXECUTE 'CREATE USER ${PG_USER} WITH PASSWORD ''${PG_PASSWORD}''';
   END IF;
END
\$\$;
"

if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='${PG_DB}'" | grep -q 1; then
  sudo -u postgres psql -c "CREATE DATABASE ${PG_DB} OWNER ${PG_USER};"
fi

# Install MongoDB
echo "--- Installing MongoDB ---"
sudo apt install -y mongodb

# Start MongoDB service
echo "--- Enabling and starting MongoDB service ---"
sudo systemctl enable mongodb
sudo systemctl start mongodb

# Create MongoDB database
echo "--- Creating MongoDB chat database ---"
mongo <<EOF
use ${CHAT_DB};
EOF

echo "=== Database setup completed successfully ==="
echo "----------------------------------------------------------------------------------"

exit 0
