#!/bin/bash

# Navigate to the WordPress directory
cd /var/www/html

# Ensure the directory is clean
rm -rf *

# Download WordPress using WP-CLI
wp core download --allow-root

# Setup WordPress configuration
wp config create --force \
                --url="$WP_URL" \
                --dbname="$DB_NAME" \
                --dbuser="$DB_USER" \
                --dbpass="$DB_PASSWORD" \
                --dbhost="mariadb:3306"

# Install WordPress
wp core install --url="$WP_URL" \
                --title="$WP_TITLE" \
                --admin_user="$WP_ADMIN_NAME" \
                --admin_password="$WP_ADMIN_PASS" \
                --admin_email="$WP_ADMIN_EMAIL" \
                --skip-email

# Create an additional WordPress user
wp user create $WP_USER_NAME \
                $WP_USER_EMAIL \
                --user_pass="$WP_USER_PASS"

# Run PHP-FPM in the foreground
php-fpm7.3 -F
