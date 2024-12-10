#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo yum install -y docker

sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker ec2-user

sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Reinicia para aplicar permissões
sudo reboot

# iniciar o wordpress
cat <<EOF > docker-compose.yml
version: '3.9'

services:

  wordpress:
    image: wordpress
    restart: always
    ports:
      - 8080:80
    environment:
      WORDPRESS_DB_HOST: ${WORDPRESS_DB_HOST}
      WORDPRESS_DB_USER: ${WORDPRESS_DB_USER}
      WORDPRESS_DB_PASSWORD: ${WORDPRESS_DB_PASSWORD}
      WORDPRESS_DB_NAME: ${WORDPRESS_DB_NAME}
    volumes:
      - wordpress:/var/www/html

volumes:
  wordpress:
EOF

# Instalar o Cliente MySQL no Amazon Linux
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo yum install mysql80-community-release-el9-1.noarch.rpm -y 
sudo yum install mysql-community-server -y
sudo rm -f /etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
sudo systemctl start mysqld