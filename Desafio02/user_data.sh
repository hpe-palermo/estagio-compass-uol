#!/bin/bash

# Atualizar pacotes
sudo yum update -y
sudo yum upgrade -y

# Instalar Docker
sudo yum install -y docker

# Iniciar e habilitar o Docker
sudo systemctl start docker
sudo systemctl enable docker

# Adicionar o usuário atual ao grupo Docker
sudo usermod -aG docker ec2-user

# Aplicar alterações de grupo sem reiniciar
newgrp docker

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Instalação concluída. Você pode usar o Docker sem reiniciar o sistema."

# Criar o arquivo docker-compose.yml
cat <<EOF > docker-compose.yml
version: '3.9'

services:

  nginx:
    image: nginx
    restart: always
    ports:
      - 80:80
    volumes:
      - nginx-v:/usr/share/nginx/html  # Caminho correto para o diretório padrão do nginx

volumes:
  nginx-v:
EOF

cat <<EOF > docker-compose.yml
version: '3.9'

services:
  nginx:
    image: nginx
    restart: always
    ports:
      - 80:80
    volumes:
      - /mnt/dados:/mnt/dados
EOF

docker run -d --name nginx -v /nginx-efs:/usr/share/nginx/html -p 80:80 nginx


# Iniciar o NGINX com Docker Compose
docker-compose up -d

# Obter o endereço IP da máquina
IP=$(hostname -I | awk '{print $1}')

# Exibir a mensagem final com o IP dinâmico
echo "NGINX iniciado. Acesse o servidor em http://$IP:80"


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

# Instalar nfs
sudo yum -y install nfs-utils
sudo systemctl enable nfs-client.target
sudo systemctl start nfs-client.target

# Montagem manual
# sudo mount -t nfs <servidor_nfs>:<diretório_compartilhado> /<ponto_de_montagem>
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-036b70ebd35018960.efs.us-east-1.amazonaws.com:/ /nginx-efs

# Montagem automática (arquivo /etc/fstab)
# <servidor_nfs>:<diretório_compartilhado>  /<ponto_de_montagem>  nfs  defaults  0  0

# Instalar o Cliente MySQL no Amazon Linux
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo yum install mysql80-community-release-el9-1.noarch.rpm -y 
sudo yum install mysql-community-server -y
sudo rm -f /etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
sudo systemctl start mysqld