#!/bin/bash
# Install git on your ubuntu 12.04.03 $ sudo apt-get install git-core
# # ssh root@<ip address>
# $ passwd
# $ <enter new password 2x>
# Then clone this repo down, change the configPG931.sh file to be executable (chmod 755 /path/to/configPG931.sh

# add the postgres repo to the bottom of the sources.list file
echo "Adding the postgres repo for Ubuntu 12.04(.03) precise"
echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" >> /etc/apt/sources.list

# add public key so you can download the postgresql setup
echo "Adding the postgres repo public key"
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -

#update with these repos quietly with no junk messages
echo "Updating"
sudo apt-get update > /dev/null

# install postres
echo "Installing Postgresql 9.3, postgis 2.1, pgadmin support and the contrib libraries so you don't get a funky error message when connecting through pgadmin"
sudo apt-get -q -y install postgresql-9.3 postgresql-9.3-postgis pgadmin3 postgresql-contrib

# open postgres port to the world
echo "Adding a line to the postgres pg_hba.conf file to allow ipv4 0.0.0.0/0 (whole world) access to the database"
sed -i "92c host	all		all		0.0.0.0/0		md5" /etc/postgresql/9.3/main/pg_hba.conf

echo "setting the listen address to be all in the postgresql.conf file"
sed -i "59c listen_addresses = '*' " /etc/postgresql/9.3/main/postgresql.conf

#create new database user
echo "Creating a user named 'postgres' with a password 'password1'"
su postgres
psql
ALTER USER postgres WITH PASSWORD 'password1';

#create a template postgis database and go in to it
echo "Creating a sample postgis enabled database named 'postgis_template'"
createdb postgis_template
psql postgis_template
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
\q

sudo su - root
# reboot postgres
echo "rebooting the postgres service, try to connect using your IP address on port 5432.  Make sure to make a security exception if your server requires in."
/etc/init.d/postgresql restart
