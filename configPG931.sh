#!/bin/bash

# ssh root@<ip address>
# passwd
# <enter new password 2x>

# add the postgres repo to the bottom of the sources.list file
echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" >> /etc/apt/sources.list

# add public key so you can download the postgresql setup
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -

#update with these repos
sudo apt-get update

# install postres
sudo apt-get install postgresql-9.3, install postgresql-9.3-postgis, pgadmin3, postgresql-contrib

#create new database user
sudo su - postgres

#create a template postgis database and go in to it
createdb postgis_template
psql postgis_template

#create extensions
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;

# open postgres port to the world
sed -i "92c host/tall/t/tall/t/t0.0.0.0/0/t/tmd5" /etc/postgresql/9.3/main/pg_hba.conf

sed -i "59c listen_addresses = '*' " /etc/postgresql/9.3/main/postgresql.conf

# reboot postgres
/etc/init.d/postgresql restart