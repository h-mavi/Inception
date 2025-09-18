#!/bin/sh

set -eux

WP_PATH=/var/www/html

cd $WP_PATH

if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "\033[1;37mDownloading WordPress core...\033[0m"
    wp core download --allow-root
    echo "\033[1;37mCreating wp-config.php...\033[0m"
    wp config create --dbname=${WORDPRESS_DB_NAME} --dbuser=${WORDPRESS_DB_USER} --dbpass=${WORDPRESS_DB_PASSWORD} --dbhost=mariadb --allow-root
    echo "\033[1;37mInstalling WordPress...\033[0m"
    wp core install --url=${DOMAIN_NAME} --title="Ora funziona?" --admin_user=${WORDPRESS_ADMIN_USER} --admin_password=${WORDPRESS_ADMIN_PASSWORD} --admin_email=${WORDPRESS_ADMIN_EMAIL} --allow-root
else
    echo "\033[1;37mWordPress already installed...\033[0m"
fi

if ! wp user get ${WORDPRESS_USER} --path=$WP_PATH --allow-root > /dev/null 2>&1; then
    echo "\033[1;37mCreating user ${WORDPRESS_USER}...\033[0m"
    wp user create ${WORDPRESS_USER} ${WORDPRESS_EMAIL} --role=author --user_pass=${WORDPRESS_PASSWORD} --path=$WP_PATH --allow-root
else
    echo "\033[1;37mUser ${WORDPRESS_USER} already exists.\033[0m"
fi

wp option update siteurl 'https://mfanelli.42.fr' --allow-root
wp option update home 'https://mfanelli.42.fr' --allow-root

echo "\033[1;37mStarting PHP-FPM...\033[0m"

exec php-fpm7.4 -F