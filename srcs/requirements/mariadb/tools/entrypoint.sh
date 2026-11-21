#!/bin/sh
set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# The volume may be empty on first start: create MariaDB's system tables.
if [ ! -d /var/lib/mysql/mysql ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db > /dev/null
fi

# Our database does not exist yet: create it, the user and the root password.
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    mariadbd --user=mysql --bootstrap <<SQL
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
FLUSH PRIVILEGES;
SQL
fi

exec mariadbd --user=mysql
