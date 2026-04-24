#!/bin/bash

set -eux

FIRST=1

export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)
export MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)

if [ ! -d /var/lib/mysql/mysql ]; then
    echo "\033[1;37mInitializing MariaDB data directory\033[0m"
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
else
    echo "\033[1;37mMariaDB data directory already initialized\033[0m"
    FIRST=0
fi

mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql

echo "\033[1;37mStarting MariaDB server\033[0m"
mysqld_safe --user=mysql --datadir=/var/lib/mysql --pid-file=/var/run/mysqld/mysqld.pid &
pid="$!"

echo "\033[1;37mWaiting for MariaDB to start...\033[0m"
for i in {30..0}; do
    if mysqladmin ping --silent; then
        break
    fi
    sleep 1
done

if [ "$i" = 0 ]; then
    echo >&2 "\033[1;37mMariaDB did not start\033[0m"
    exit 1
fi

if [ "$FIRST" -eq "1" ]; then
    DB_PASS=""
    echo "\033[1;37mFirst time setup\033[0m"
else
    DB_PASS="-p${MYSQL_ROOT_PASSWORD}"
    echo "\033[1;37mNot first time setup\033[0m"
fi

echo "\033[1;37mSetting up database and users\033[0m"
mysql -u "${MYSQL_ROOT_USER}" ${DB_PASS} <<EOSQL
    CREATE USER IF NOT EXISTS '${MYSQL_ROOT_USER}'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    ALTER USER '${MYSQL_ROOT_USER}'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_ROOT_USER}'@'localhost' WITH GRANT OPTION;
    FLUSH PRIVILEGES;

    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    ALTER USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

mysqladmin -u "${MYSQL_ROOT_USER}" -p"${MYSQL_ROOT_PASSWORD}" shutdown
wait "$pid"

echo "\033[1;37mStarting MariaDB server in foreground \033[0m"
mysqld --user=mysql --datadir=/var/lib/mysql --pid-file=/var/run/mysqld/mysqld.pid


#- - - - - - - - - - - - - - - -
# Scarti
# mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
#- - - - - - - - - - - - - - - -
# (line 23)
# #& a fine e' per far partire il server in background per poter esuire il ping
#- - - - - - - - - - - - - - - -
# (line 27)
# ciclo da 30 a 0, aspetta 31s
#- - - - - - - - - - - - - - - -
# (line 35)
# >&2 manda l'output su stderr
#- - - - - - - - - - - - - - - -
# (line 48-61)
# '<<EOSQL' dice alla shell che tutto quello che segue, fino alla riga che contiene 
# solo 'EOSQL', va passato come input al comando precedente mysql