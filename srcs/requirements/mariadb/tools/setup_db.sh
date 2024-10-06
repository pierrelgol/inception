#!/bin/bash

service mariadb start

# Wait until MariaDB is up
while ! mysqladmin ping --silent; do
    sleep 1
done

# Ensure that the SQL_ROOT_PASSWORD variable is set
if [[ -z "${SQL_ROOT_PASSWORD}" ]]; then
    echo "SQL_ROOT_PASSWORD is not set."
    exit 1
fi

# Create root user with the provided password
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

# Create the database and user
mysql -u root -p${SQL_ROOT_PASSWORD} <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';
    CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
    FLUSH PRIVILEGES;  -- Make sure to flush privileges after user creation
EOSQL

# Grant privileges after confirming user creation
mysql -u root -p${SQL_ROOT_PASSWORD} <<-EOSQL
    GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'localhost';
    GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
    FLUSH PRIVILEGES;
EOSQL

if ! mysqladmin ping -u root -p${SQL_ROOT_PASSWORD} --silent; then
    echo "MariaDB is not running or accessible. Exiting."
    exit 1
fi

mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown
exec mysqld_safe
