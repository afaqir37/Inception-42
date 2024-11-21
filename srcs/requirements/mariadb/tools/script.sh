#!/bin/bash

# Initialize MySQL data directory if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MySQL service
mysqld --user=mysql &

# Wait for MySQL to be ready
until mysqladmin ping >/dev/null 2>&1; do
    echo "Waiting for MySQL to be ready..."
    sleep 1
done

# Now execute your setup commands
mariadb -u root -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
mariadb -u root -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mariadb -u root -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"
mariadb -u root -e "FLUSH PRIVILEGES;"
mariadb -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWORD');"
mariadb -u root -e "FLUSH PRIVILEGES;"
mariadb -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
mariadb -u root -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

# Stop the temporary MySQL daemon
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

# Start MySQL in safe mode
exec mysqld_safe
