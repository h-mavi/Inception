all :
				cd srcs && \
				docker-compose up --build && docker-compose start

build :
				cd srcs && \
				docker-compose up --build

run :
				cd srcs && \
				docker-compose start
stop :
				cd srcs && \
				docker-compose stop && docker-compose down

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