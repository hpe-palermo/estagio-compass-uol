# Projeto: Implantação de WordPress na AWS

Este projeto demonstra a configuração e o deployment de uma aplicação WordPress utilizando serviços da AWS. O objetivo é criar uma infraestrutura escalável e altamente disponível, composta pelos seguintes componentes:

## Arquitetura do Projeto
-  **Duas Instâncias de Servidor WordPress:**
	- Contêineres que hospedam a aplicação WordPress.
	- Compartilham os arquivos estáticos via Amazon EFS para garantir consistência entre as instâncias.

- **Amazon RDS (Relational Database Service):**
	- Serviço gerenciado de banco de dados utilizado para armazenar os dados do WordPress, como configurações, posts e usuários.

- **Load Balancer:**
	- Balanceador de carga da AWS que distribui o tráfego entre as instâncias do WordPress, garantindo alta disponibilidade e escalabilidade.

- **Amazon EFS (Elastic File System):**
	- Sistema de arquivos compartilhado utilizado para armazenar arquivos estáticos do WordPress (uploads, temas e plugins), acessível simultaneamente por todas as instâncias.

## Etapas do Projeto
-  **Instalação e Configuração:**
	- Configuração das instâncias EC2 utilizando um script de inicialização (user_data.sh) para instalação automática do Docker ou Containerd e os componentes necessários.

- **Deploy do WordPress:**
	- Contêineres de aplicação WordPress conectados ao RDS para gerenciamento do banco de dados.

- **Integração com Amazon EFS:**
	- Configuração do sistema de arquivos compartilhado para armazenar arquivos estáticos.

- **Configuração do Load Balancer:**
	- Criação de um Load Balancer para distribuir o tráfego entre as instâncias do WordPress, garantindo alta disponibilidade.