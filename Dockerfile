# Dockerfile

FROM ubuntu:22.04

# Set environment
ENV DEBIAN_FRONTEND=noninteractive
ENV NVM_DIR=/root/.nvm

RUN apt update && apt install -y \
  curl ca-certificates sudo gnupg software-properties-common unzip git make dos2unix \
  mariadb-client nginx php8.2 php8.2-{cli,fpm,mysql,mbstring,xml,curl,bcmath,zip,redis} \
  redis-server nodejs npm php8.2-fpm php8.2-mysql \
  && rm -rf /var/lib/apt/lists/*

# Install NVM + Node 22 + Yarn
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash && \
  . "$NVM_DIR/nvm.sh" && \
  nvm install 22 && \
  nvm alias default 22 && \
  npm install -g yarn

# Copy source code
WORKDIR /var/www/mythicaldash
COPY . .

# Entrypoint setup
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80 443 6000

CMD ["/entrypoint.sh"]
