FROM debian:buster

# Update and install necessary packages
RUN apt update && apt install -y php-fpm php-mysql curl

# Download and configure WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Adjust PHP-FPM configuration


RUN sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    mkdir -p /run/php /var/www /var/log/php && \
    chown -R www-data:www-data /run/php /var/www /var/log /etc/php/7.3/fpm/pool.d

# Copy the WordPress setup script and make it executable
COPY ./tools/script.sh /usr/local/bin/wordpress_setup.sh
RUN chmod +x /usr/local/bin/wordpress_setup.sh

# Expose the port PHP-FPM listens on
EXPOSE 9000

# Switch to the www-data user for security
USER www-data

# Run the setup script
CMD [ "/usr/local/bin/wordpress_setup.sh" ]
