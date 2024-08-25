#!/bin/bash

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

service mysql start

sleep 5

echo "Creatng DB and USER for wordpress..."

echo "CREATE DATABASE IF NOT EXISTS $DB_NAME;" > db1.sql
echo "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD' ;" >> db1.sql
echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' ;" >> db1.sql
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '12345' ;" >> db1.sql
echo "FLUSH PRIVILEGES;" >> db1.sql

mysql < db1.sql

echo "Restating mysql deamon..."

kill $(cat /var/run/mysqld/mysqld.pid)

mysqld