#!/bin/bash

create_sql_file() {
	cat << EOF > bootstrap.sql
	FLUSH PRIVILEGES;
	CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
	CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
	GRANT ALL PRIVILEGES on \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
	FLUSH PRIVILEGES;
EOF
}

run_bootstrap() {
	mysqld --user=mysql --bootstrap < bootstrap.sql
	rm -f bootstrap.sql
}

if [ ! -d "/var/lib/mysql/${DB_NAME}" ]; then
	create_sql_file
	run_bootstrap
fi

exec /usr/sbin/mysqld --datadir=/var/lib/mysql --user=mysql
