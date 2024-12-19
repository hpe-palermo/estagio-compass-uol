
# Desafio 02 - Projeto: Implantação de WordPress na AWS

![Logo da Eagle Tecnologia](./logo.jpg)

## Introdução

Este projeto demonstra a configuração e o deployment de uma aplicação WordPress utilizando serviços da AWS, criando uma infraestrutura escalável e altamente disponível.



## Arquitetura do Projeto

-  **Duas Instâncias de Servidor WordPress:**
    
	-   Contêineres que hospedam a aplicação WordPress.
	- 	Compartilham os arquivos estáticos via Amazon EFS para garantir consistência entre as instâncias.  
      
    

-   **Amazon RDS (Relational Database Service):**
    
	-   Serviço gerenciado de banco de dados utilizado para armazenar os dados do WordPress, como configurações, posts e usuários.  
      
    

-   **Load Balancer:**   

	-   Balanceador de carga da AWS que distribui o tráfego entre as instâncias do WordPress, garantindo alta disponibilidade e escalabilidade.  
          

-   **Amazon EFS (Elastic File System):**
    
	-   Sistema de arquivos compartilhado utilizado para armazenar arquivos estáticos do WordPress (uploads, temas e plugins), acessível simultaneamente por todas as instâncias.
  
  

## Etapas do Projeto

Nesta etapa, é demonstrado as configurações dos recursos necessários para a criação da arquitetura do projeto e sua execução/inicialização.

  

-   **VPC**

	-   Passo 1: Descrição  


-  **Security Groups**
    
	-   Passo 1: Descrição  
      
-   **Internet Gateway**

	-   Passo 1: Descrição  
    
-   **Route Table**
    
	-   Passo 1: Descrição  
   
-   **Subnets**
    
	-   Passo 1: Descrição  
  
-   **EFS**
    
	-   Passo 1: Descrição  
    
-   **RDS**
    
	-   Passo 1: Descrição  
    
-   **Instâncias**
    
-   Passo 1: Descrição  
   
   

    ## Script de Instalação/Configuração/Inicialização 
    O script de inicialização (user_data.sh) para instalação automática do Docker, configuração do docker-compose.yml para a criação dos containers do WordPress.
    
