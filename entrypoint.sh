#!/bin/bash

export NVM_DIR="/root/.nvm"
source "$NVM_DIR/nvm.sh"
nvm use 22

# Build frontend
cd /var/www/mythicaldash/frontend
yarn install --ignore-engines --force
yarn build

# Install backend
cd /var/www/mythicaldash/backend
composer install --no-interaction --prefer-dist

# Start services
service php8.2-fpm start
service nginx start
service redis-server start

# Wait for MariaDB to become available
until mysql -hmariadb -umySQLuser -p"$MYSQL_PASSWORD" -e "SHOW DATABASES;"; do
  echo "Waiting for MariaDB..."
  sleep 3
done

# Setup panel
cd /var/www/mythicaldash
php mythicaldash setup
php mythicaldash migrate
php mythicaldash pterodactyl configure
php mythicaldash init
php mythicaldash makeAdmin

# Keep container running
tail -f /dev/null
