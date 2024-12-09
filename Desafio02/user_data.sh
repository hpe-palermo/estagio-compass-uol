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
# olhar EOF Linux - ele ja formata!
# cat <<EOF > nome_arquivo
# conteudo
# EOF