FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV NVM_DIR=/root/.nvm

# Install packages
RUN apt update && apt install -y \
  curl ca-certificates sudo gnupg software-properties-common unzip git make dos2unix \
  mariadb-client nginx php8.2 php8.2-{cli,fpm,mysql,mbstring,xml,curl,bcmath,zip,redis} \
  redis-server php8.2-fpm php8.2-mysql nodejs npm \
  && rm -rf /var/lib/apt/lists/*

# Install NVM + Node 22
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install 22 && nvm alias default 22 && npm install -g yarn"

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Download MythicalDash release
WORKDIR /var/www/mythicaldash
RUN curl -Lo MythicalDash.zip https://github.com/MythicalLTD/MythicalDash/releases/latest/download/MythicalDash.zip \
  && unzip MythicalDash.zip -d . \
  && rm MythicalDash.zip

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80 443 6000
CMD ["/entrypoint.sh"]
