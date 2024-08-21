FROM debian:buster

RUN apt update -y && apt upgrade -y && apt-get install mariadb-server procps -y

# Here the 99-custom allows mariadb to process this config file at the
# end as it processes config files in alphabetical order and this allows
# it to override the previously set parameters.
COPY conf/mariadb.cnf /etc/mysql/mariadb.conf.d/99-custom.cnf

# Copy the startup script into the container
COPY tools/init_mariadb.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Set environment variables
ENV DB_NAME=wordpress_db \
	DB_USER=wordpress_user \
	DB_PASSWORD=secure_password \
	ROOT_PASSWORD=root_password

EXPOSE 3306

CMD ["/usr/local/bin/startup.sh"]
