#!/bin/bash

# Ensure the MariaDB service is started
service mysql start

# Wait for MariaDB to start up completely
while ! mysqladmin ping --silent; do
	sleep 1
done

# Check if the initial setup needs to be run
if [ ! -f "/var/lib/mysql/initialized.flag" ]; then
	# Create the initial setup flag file
	touch /var/lib/mysql/initialized.flag

	# Secure the installation (set root password and apply security settings)
	mysql_secure_installation <<EOF

y    # Set root password
${ROOT_PASSWORD}
${ROOT_PASSWORD}
y    # Remove anonymous users
y    # Disallow root login remotely
y    # Remove test database and access to it
y    # Reload privilege tables now
EOF

	# SQL to set up initial database and user
	mysql -u root -p"${ROOT_PASSWORD}" <<-EOSQL
		CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
		CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
		FLUSH PRIVILEGES;
		SHOW DATABASES;
EOSQL
fi

/etc/init.d/mysql stop

exec "$@"