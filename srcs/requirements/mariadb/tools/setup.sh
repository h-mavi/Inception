#!/bin/bash

set -e
# /bin/bash -> lo script va runnato in bash
# set -e    -> se qualsiasi comando fallisce lo scrpti esce immediatamente

echo "Env var disponibili :"
env | grep MYSQL


FIRST=1

if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Initializing MariaDB data directory"
    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
    #mysql_install_db --user=mysql --datadir=/var/lib/mysql
else
    echo "MariaDB data directory already initialized"
    FIRST=0
fi
# /var/lib/mysql/mysql         -> dove MariaDB tiene le system tables, se la dir non esiste e' la prima run del container
# mysqld --initialize-insecure -> setta i system tables e le dir
# FIRST                        -> per differenziare la prima run dalle altre


# Ensure the directory for the Unix socket exists
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql
# /var/run/mysqld -> serve a MariaDB per contenere i suoi PID e socket files, la ownership deve essere corretta in modo che il processo
#                    ci possa scrivere


echo "Starting MariaDB server"
mysqld_safe --user=mysql --datadir=/var/lib/mysql --pid-file=/var/run/mysqld/mysqld.pid &
pid="$!"
# mysqld_safe -> fa partire il server di MariaDB (se carasha si restarta)
# &           -> per farlo runnare in background almeno lo script pu' continuare
# pid="$!"    -> cattura ID del processo per usarlo dopo per fernarlo 


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
# for i in {30..0}; do ... -> looppa per 30s per controllare che MariaDB risponda sempre
# mysqladmin ping          -> ritorna success se il server e' pronto
# se fallisce dopo 30s lo script esce con un errore


# Database Setup
if [ "$FIRST" -eq "1" ]; then
    DB_PASS=""
    echo "First time setup"
else
    DB_PASS="-p${MYSQL_ROOT_PASSWORD}"
    echo "Not first time setup"
fi
# DB_PASS="" -> se e' la prima run del server, la root password non e' settata, senno' gli si passa laf
#               rootpassword.


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
# CREATE USER IF NOT EXISTS ... -> crea un root user se non esiste, sia per localhost che per remoto,
#                                  il IF NOT EXIST usato per non far uscire errori in caso di un re-run
# ALTER USER ...                -> setta la password per il root
# CREATE DATABASE ...           -> crea il database
# CREATE USER IF NOT EXISTS ... -> crea il database user con i suoi privilegi


echo "Stopping MariaDB server"

mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
wait "$pid"
# 'Gracefully' butta giu' il server di MariaDB dopo che l'inizializzazione e' finita
# wait "$pid" -> si assicura che tutto sia finito in modo corretto


echo "Restarting MariaDB server"
touch /tmp/mariadb_ready
mysqld --user=mysql --datadir=/var/lib/mysql --pid-file=/var/run/mysqld/mysqld.pid
# touch /tmp/mariadb_ready -> un marker file che potra' essere usato da altri servizi per
#                             controllare che e' tutto pronto
# mysqld ...               -> fa partire MariaDB nel foreground