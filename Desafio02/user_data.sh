#!/bin/bash

# Variáveis
export ENDERECO_EFS="fs-076301ce247ea6dcc.efs.us-east-1.amazonaws.com"
export WORDPRESS_DB_HOST="my-database.c1ue0wu6y89k.us-east-1.rds.amazonaws.com"
export WORDPRESS_DB_USER="admin"
export WORDPRESS_DB_PASSWORD="nduhr02-02ffk4"
export WORDPRESS_DB_NAME="dp_wp"

# Atualizar pacotes
sudo yum update -y
sudo yum upgrade -y

# Instalar Docker
sudo yum install -y docker

# Iniciar e habilitar o Docker
sudo systemctl start docker
sudo systemctl enable docker

# Mudar para o usuário 'root'
sudo su

# Instalar Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Instalar nfs
sudo yum -y install nfs-utils
sudo systemctl enable nfs-client.target
sudo systemctl start nfs-client.target

# Montagem do sistema de arquivos
sudo mkdir -p /mnt/dados
echo "$ENDERECO_EFS:/ /mnt/dados nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport 0 0" | sudo tee -a /etc/fstab

# Limpar cache NFS
echo 3 > /proc/sys/vm/drop_caches

# Reiniciar o sistema de arquivos
sudo systemctl restart sudo systemctl restart nfs-utils

# Iniciar o WordPress
cat <<EOF > docker-compose.yml
version: '3.9'

services:

  wordpress:
    image: wordpress
    restart: always
    ports:
      - 8080:80
    environment:
      WORDPRESS_DB_HOST: $WORDPRESS_DB_HOST
      WORDPRESS_DB_USER: $WORDPRESS_DB_USER
      WORDPRESS_DB_PASSWORD: $WORDPRESS_DB_PASSWORD
      WORDPRESS_DB_NAME: $WORDPRESS_DB_NAME
    volumes:
      - wordpress:/var/www/html

volumes:
  wordpress:
    driver_opts:
      type: nfs
      o: addr=$ENDERECO_EFS,rw
      device: ":/mnt/dados"
EOF

# Ou com 'docker run'
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-076301ce247ea6dcc.efs.us-east-1.amazonaws.com:/ /mnt/dados
docker rm -f wordpress
docker run -d \
  --name wordpress \
  -p 80:80 \
  -e WORDPRESS_DB_HOST=$WORDPRESS_DB_HOST \
  -e WORDPRESS_DB_USER=$WORDPRESS_DB_USER \
  -e WORDPRESS_DB_PASSWORD=$WORDPRESS_DB_PASSWORD \
  -e WORDPRESS_DB_NAME=$WORDPRESS_DB_NAME \
  -v /mnt/dados:/var/www/html \
  --restart always \
  wordpress


# ------------------------------------------------------------------------------------------------------------

# # Criar o arquivo docker-compose.yml
# cat <<EOF > docker-compose.yml
# version: '3.9'

# services:

#   nginx:
#     image: nginx
#     restart: always
#     ports:
#       - 8080:80
#     volumes:
#       - nginx-v:/usr/share/nginx/html  # Caminho correto para o diretório padrão do nginx

# volumes:
#   nginx-v:
# EOF

# Criar o arquivo docker-compose.yml
# cat <<EOF > docker-compose.yml
# version: '3.9'

# services:
#   nginx:
#     image: nginx
#     restart: always
#     ports:
#       - 8080:80
#     volumes:
#       - /mnt/dados:/mnt/dados
# EOF

# # Iniciar conteiner docker Nginx
# docker run -d --name nginx -v /nginx-efs:/usr/share/nginx/html -p 80:80 nginx

# # Iniciar o Docker Compose
# docker-compose up -d

# ------------------------------------------------------------------------------------------------------------

# Instalar o Cliente MySQL no Amazon Linux
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo yum install mysql80-community-release-el9-1.noarch.rpm -y 
sudo yum install mysql-community-server -y
sudo systemctl start mysqld
