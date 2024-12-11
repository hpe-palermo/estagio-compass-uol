#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo yum install -y docker

sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker ec2-user

sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Reinicia para aplicar permissões(encontrar outra maneira)
sudo reboot

# iniciar o nginx
cat <<EOF > docker-compose.yml
version: '3.9'

services:

  nginx:
    image: nginx
    restart: always
    ports:
      - 8080:80
    volumes:
      - nginx-v:/usr/share/nginx/html  # Caminho correto para o diretório padrão do nginx

volumes:
  nginx-v:
EOF

dokcer-compose up -d

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
      WORDPRESS_DB_HOST: db-wp.c1ue0wu6y89k.us-east-1.rds.amazonaws.com
      WORDPRESS_DB_USER: admin
      WORDPRESS_DB_PASSWORD: nduhr02-02ffk4
      WORDPRESS_DB_NAME: db_wp
    volumes:
      - wordpress:/var/www/html

volumes:
  wordpress:

version: '3.9'

services:

  nginx:
    image: nginx
    restart: always
    ports:
      - 8080:80
    volumes:
      - nginx-v:/usr/share/nginx/html

volumes:
  nginx:
EOF

# Instalar o Cliente MySQL no Amazon Linux
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo yum install mysql80-community-release-el9-1.noarch.rpm -y 
sudo yum install mysql-community-server -y
sudo rm -f /etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
sudo systemctl start mysqld