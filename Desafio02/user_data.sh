#!/bin/bash
# Atualiza o sistema e instala dependências
sudo yum update -y
sudo yum upgrade -y
sudo yum install -y docker

# Inicia o Docker e configura para iniciar com o sistema
sudo systemctl start docker
sudo systemctl enable docker

# Adiciona o usuário atual ao grupo docker
sudo usermod -aG docker ec2-user

# Instala o Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Reinicia para aplicar permissões
sudo reboot