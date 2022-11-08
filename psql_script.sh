#!/usr/bin/env bash

# Install required software packages.
echo "Installing requirements ============="
sudo apt install wget ca-certificates -y

# Add certificate to apt
echo "Add certificate to apt =============="
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Create a config file for PostgreSQL repo
echo "Creating config file for PostgreSQL repo ============"
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'

# Update apt
echo "Updating apt info ===================="
sudo apt update -y

# PostgreSQL installation
echo "Installing PostgreSQL =================="
sudo apt install postgresql postgresql-contrib -y

# Ensure that the service is started:
echo "Ensuring PostgreSQL service is started ================"
sudo systemctl start postgresql.service

# Setting up a new role/user:
echo "Creating a new role/user ================"
createuser -s $whoami

# Setting up a new db:
echo "Creating a new database ================"
createdb newdb

# Setting up Postgres
echo "Uncomment and edit the listen_addresses attribute ==============="
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/14/main/postgresql.conf

# Edit the PostgreSQL access policy
echo "Editing PostgreSQL access policy ======================="
sudo echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/14/main/pg_hba.conf

# Restart Postgres service:
echo "Restarting PostgreSQL service ===================="
sudo systemctl restart postgresql

# Make server listen on port 5432
echo "Listening on port 5432 ======================="
sudo ss -nlt | grep 5432