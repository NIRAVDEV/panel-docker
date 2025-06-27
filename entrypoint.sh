#!/bin/bash

# Load NVM
export NVM_DIR="/root/.nvm"
. "$NVM_DIR/nvm.sh"
nvm use 22

# Install frontend
cd /var/www/mythicaldash/frontend
yarn install --ignore-engines --force
yarn build

# Install backend
cd /var/www/mythicaldash/backend
composer install --no-interaction --prefer-dist

# Start PHP-FPM and NGINX
service php8.2-fpm start
service nginx start

# Start backend panel
php /var/www/mythicaldash/mythicaldash setup
php /var/www/mythicaldash/mythicaldash migrate
php /var/www/mythicaldash/mythicaldash pterodactyl configure
php /var/www/mythicaldash/mythicaldash init
php /var/www/mythicaldash/mythicaldash makeAdmin

# Keep container running
tail -f /dev/null
