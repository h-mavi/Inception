#!/bin/sh

set -eux

WP_PATH=/var/www/html

cd $WP_PATH

echo "Database is ready!"

# Download WordPress core
if [ ! -f "$WP_PATH/wp-config.php" ]; then
    #echo "Downloading WordPress core..."
    #wp core download --allow-root
    echo "Creating wp-config.php..."
    wp config create --dbname=${WORDPRESS_DB_NAME} --dbuser=${WORDPRESS_DB_USER} --dbpass=${WORDPRESS_DB_PASSWORD} --dbhost=mariadb --allow-root
    echo "Installing WordPress..."
    wp core install --url=mfanelli.42.fr --title="HALOOOOW" --admin_user=${WORDPRESS_ADMIN_USER} --admin_password=${WORDPRESS_ADMIN_PASSWORD} --admin_email=${WORDPRESS_ADMIN_EMAIL} --allow-root
else
    #echo "WordPress core already downloaded."
    echo "wp-config.php already exists."
    echo "WordPress is already installed."
fi

# Create a user if it doesn't exist
if ! wp user get ${WORDPRESS_USER} --path=$WP_PATH --allow-root > /dev/null 2>&1; then
    echo "Creating user ${WORDPRESS_USER}..."
    wp user create ${WORDPRESS_USER} ${WORDPRESS_EMAIL} --role=author --user_pass=${WORDPRESS_PASSWORD} --path=$WP_PATH --allow-root
else
    echo "User ${WORDPRESS_USER} already exists."
fi

# Install and activate a theme if it's not already installed
#if ! wp theme is-installed dark-mode --path=$WP_PATH --allow-root; then
#    echo "Installing and activating theme 'dark-mode'..."
#    wp theme install --allow-root dark-mode --activate
#else
#    echo "Theme 'dark-mode' is already installed and active."
#fi

wp plugin update --all --allow-root

# Correggi gli URL di WordPress
echo "Fixing WordPress URLs..."
wp option update siteurl 'https://mfanelli.42.fr' --allow-root
wp option update home 'https://mfanelli.42.fr' --allow-root

echo "Starting PHP-FPM..."
# Start PHP-FPM in foreground to keep container running
exec php-fpm7.4 -F