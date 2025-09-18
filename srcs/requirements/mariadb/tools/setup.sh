#!/bin/bash

set -eux

FIRST=1

if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Initializing MariaDB data directory"
    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
else
    echo "MariaDB data directory already initialized"
    FIRST=0
fi

mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql

echo "Starting MariaDB server"
mysqld_safe --user=mysql --datadir=/var/lib/mysql --pid-file=/var/run/mysqld/mysqld.pid &
pid="$!"

echo "Waiting for MariaDB to start... (pid: $pid)"
for i in {30..0}; do
    if mysqladmin ping --silent; then
        break
    fi
    sleep 1
done

if [ "$i" = 0 ]; then
    echo >&2 "MariaDB did not start"
    exit 1
fi

if [ "$FIRST" -eq "1" ]; then
    DB_PASS=""
    echo "First time setup"
else
    DB_PASS="-p${MYSQL_ROOT_PASSWORD}"
    echo "Not first time setup"
fi

echo "Setting up database and users"
mysql -u root ${DB_PASS} <<EOSQL
    CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    ALTER USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

    GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
    FLUSH PRIVILEGES;

    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    ALTER USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

echo "Stopping MariaDB server"

mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
wait "$pid"

echo "Restarting MariaDB server"
touch /tmp/mariadb_ready
mysqld --user=mysql --datadir=/var/lib/mysql --pid-file=/var/run/mysqld/mysqld.pid
