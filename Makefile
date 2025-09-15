all :
				cd srcs && \
				docker-compose up --build && docker-compose start

build :
				cd srcs && \
				docker-compose up --build

run :
				cd srcs && \
				docker-compose start
down :
				cd srcs && \
				docker-compose down

stop :
				cd srcs && \
				docker-compose stop

nginx :
				cd srcs/requirements/nginx && \
				docker build -t nginx . && docker run -p 443:443 nginx

mariadb :
				cd srcs/requirements/mariadb && \
				docker build -t mariadb . && docker run -p 3306:3306 mariadb

clean :
				docker system prune -af --volumes && docker volume rm srcs_mariadb_data srcs_wordpress_data

logs :
				cd srcs && \
				docker-compose logs

ls :
				docker ps && \
				echo "-----------------------------------------------------------------------" && \
				docker image ls && \
				echo "-----------------------------------------------------------------------" && \
				docker volume ls

.SILENT:



#mariadb      | MariaDB data directory already initialized
#mariadb      | Starting MariaDB server
#mariadb      | Waiting for MariaDB to start... (pid: 10)
#mariadb      | 250915 08:53:50 mysqld_safe Logging to syslog.
#mariadb      | 250915 08:53:50 mysqld_safe Starting mariadbd daemon with databases from /var/lib/mysql
#mariadb      | Not first time setup
#mariadb      | Setting up database and users
#mariadb      | Stopping MariaDB server
#mariadb      | Restarting MariaDB server
#mariadb      | MariaDB data directory already initialized
#mariadb      | Starting MariaDB server
#mariadb      | Waiting for MariaDB to start... (pid: 9)
#mariadb      | 250915 08:55:34 mysqld_safe Logging to syslog.
#mariadb      | 250915 08:55:34 mysqld_safe Starting mariadbd daemon with databases from /var/lib/mysql
#mariadb      | Not first time setup
#mariadb      | Setting up database and users
#mariadb      | Stopping MariaDB server
#mariadb      | Restarting MariaDB server
#wordpress    | Database is ready!
#wordpress    | Downloading WordPress core...
#wordpress    | + WP_PATH=/var/www/html
#wordpress    | + cd /var/www/html
#wordpress    | + echo Database is ready!
#wordpress    | + [ ! -f /var/www/html/wp-config.php ]
#wordpress    | + echo Downloading WordPress core...
#wordpress    | + wp core download --allow-root
#wordpress    | Downloading WordPress 6.8.2 (en_US)...
#wordpress    | md5 hash verified: 0feb479400df798eb8a46a4ce6cd1205
#wordpress    | Success: WordPress downloaded.
#wordpress    | + echo Creating wp-config.php...
#wordpress    | + wp config create --dbname=wordpress --dbuser=mywpuser --dbpass=mywppassword --dbhost=mariadb --allow-root
#wordpress    | Creating wp-config.php...
#wordpress    | Success: Generated 'wp-config.php' file.
#wordpress    | + echo Installing WordPress...
#wordpress    | Installing WordPress...
#wordpress    | + wp core install --url=localhost --title=Ora funziona? --admin_user=super --admin_password=passsuperword --admin_email=super@kmail.com --allow-root
#wordpress    | Success: WordPress installed successfully.
#wordpress    | + wp user get wpuser --path=/var/www/html --allow-root
#wordpress    | + echo Creating user wpuser...
#wordpress    | Creating user wpuser...
#wordpress    | + wp user create wpuser user@kmail.com --role=author --user_pass=userpass --path=/var/www/html --allow-root
#wordpress    | Success: Created user 2.
#wordpress    | + wp plugin update --all --allow-root
#wordpress    | Downloading update from https://downloads.wordpress.org/plugin/akismet.5.5.zip...
#wordpress    | Unpacking the update...
#wordpress    | Installing the latest version...
#wordpress    | Removing the old version of the plugin...
#wordpress    | Plugin updated successfully.
#wordpress    | name     old_version     new_version     status
#wordpress    | akismet  5.4     5.5     Updated
#wordpress    | Success: Updated 1 of 1 plugins.
#wordpress    | + echo Starting PHP-FPM...
#wordpress    | Starting PHP-FPM...
#wordpress    | + exec php-fpm7.4 -F
#wordpress    | + WP_PATH=/var/www/html
#wordpress    | + cd /var/www/html
#wordpress    | + echo Database is ready!
#wordpress    | + [ ! -f /var/www/html/wp-config.php ]
#wordpress    | + echo wp-config.php already exists.
#wordpress    | + echo WordPress is already installed.
#wordpress    | + wp user get wpuser --path=/var/www/html --allow-root
#wordpress    | Database is ready!
#wordpress    | wp-config.php already exists.
#wordpress    | WordPress is already installed.
#wordpress    | + echo Creating user wpuser...
#wordpress    | + wp user create wpuser user@kmail.com --role=author --user_pass=userpass --path=/var/www/html --allow-root
#wordpress    | Creating user wpuser...
#wordpress    | Error: Error establishing a database connection.
#altro errore wtf

# Attaching to nginx, wordpress, mariadb
# wordpress    | + WP_PATH=/var/www/html
# wordpress    | + cd /var/www/html
# wordpress    | + echo Database is ready!
# wordpress    | + [ ! -f /var/www/html/wp-config.php ]
# wordpress    | + echo wp-config.php already exists.
# wordpress    | + echo WordPress is already installed.
# wordpress    | + wp user get wpuser --path=/var/www/html --allow-root
# wordpress    | Database is ready!
# wordpress    | wp-config.php already exists.
# wordpress    | WordPress is already installed.
# wordpress    | + echo Creating user wpuser...
# wordpress    | + wp user create wpuser user@kmail.com --role=author --user_pass=userpass --path=/var/www/html --allow-root
# wordpress    | Creating user wpuser...
# wordpress    | Error: The 'wpuser' username is already registered.
# mariadb      | MariaDB data directory already initialized
# mariadb      | Starting MariaDB server
# mariadb      | Waiting for MariaDB to start... (pid: 10)
# mariadb      | 250912 14:46:19 mysqld_safe Logging to syslog.
# mariadb      | 250912 14:46:19 mysqld_safe Starting mariadbd daemon with databases from /var/lib/mysql
# mariadb      | Not first time setup
# mariadb      | Setting up database and users
# mariadb      | Stopping MariaDB server
# mariadb      | Restarting MariaDB server

#continua a non funzionare sempre, e c'e' da sistemare la cosa dell'url
#fonti : https://www.digitalocean.com/community/tutorials/nginx-rewrite-url-rules