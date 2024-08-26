#!/bin/bash

# Function to create SQL commands to set up the database and user
create_sql_file() {
    cat << EOF > bootstrap.sql
    FLUSH PRIVILEGES;
    CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
    CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
    GRANT ALL PRIVILEGES on \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
    FLUSH PRIVILEGES;
EOF
}

# Function to run the bootstrap SQL script
run_bootstrap() {
    # Use mysqld to run the bootstrap commands
    mysqld --user=mysql --bootstrap < bootstrap.sql
    rm -f bootstrap.sql
}

# Main execution block
if [ ! -d "/var/lib/mysql/${DB_NAME}" ]; then
    create_sql_file
    run_bootstrap
fi

# Start the MariaDB server
exec /usr/sbin/mysqld --datadir=/var/lib/mysql --user=mysql
