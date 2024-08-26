# Use Debian Buster as the base image
FROM debian:buster

# Update packages and install MariaDB and its client
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Create necessary directories and set permissions
RUN mkdir -p /var/lib/mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# Copy the MariaDB configuration file
COPY ./conf/mariadb.cnf /etc/mysql/mariadb.conf.d/my.cnf

# Initialize the database
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Copy the initialization script and make it executable
COPY ./tools/init_mariadb.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Expose the port MariaDB listens on
EXPOSE 3306

# Set the container's entry point to the initialization script
CMD [ "/usr/local/bin/startup.sh" ]
