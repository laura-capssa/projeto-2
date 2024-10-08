# Documentação do projeto: Deploy de Aplicação Wordpress na AWS

## Estrutura do Projeto
Instalação e Configuração do Docker/containerd no Host EC2
Deploy de uma Aplicação WordPress com Container de Aplicação e RDS Database MySQL
Configuração do Serviço EFS AWS para Arquivos Estáticos do WordPress
Configuração do Load Balancer AWS para Gerenciar Tráfego da Aplicação

1. Criar a Instância EC2
Acesse o console da AWS e crie uma nova instância EC2.
Escolha a imagem  Ubuntu como SO.
Configure as permissões de segurança (Security Groups) para permitir tráfego apenas nas portas 80 e 8080.

2. Configuração da VPC
   ![image](https://github.com/user-attachments/assets/35567399-770d-4804-990d-d6fe5fbd447c)

3. Configuração do security group
![image](https://github.com/user-attachments/assets/309c3cc6-6d06-4ca4-a950-a3cf3e49f321)


4. Configuração do Script de Instância (user_data.sh)
Utilize um script user_data.sh para automatizar a instalação do Docker/containerd. Um exemplo de script pode incluir:

```bash
#!/bin/bash
yum update -y
yum install docker -y
service docker start
usermod -a -G docker ec2-user
```
![image](https://github.com/user-attachments/assets/bc80efc5-2e80-40b5-952e-8f5cd1d133b4)


4. Verificar a Instalação do Docker
Verifique se o Docker foi instalado corretamente:

```bash
docker --version
```

## Configuração do Banco de Dados MySQL no RDS
1. Criar Instância do RDS MySQL
No console da AWS, crie uma instância RDS com MySQL.
Configure as sub-redes e permissões de acesso.
2. Configurar Segurança do RDS
Certifique-se de que a instância RDS está acessível pelas instâncias EC2, configurando os grupos de segurança adequadamente.
![image](https://github.com/user-attachments/assets/cdda6391-1add-4dfb-91cf-d83f9ca0011d)

3. Testar a Conexão
Teste a conexão do banco de dados:

```bash
mysql -h <endereço_do_banco> -P 5432 -u laura -p
```

![image](https://github.com/user-attachments/assets/030baba7-2cf6-449f-990a-bbbac9422999)


4. Criação do Docker Compose
Inicie a criação do arquivo docker-compose.yml para integrar o WordPress com o RDS MySQL.
![image](https://github.com/user-attachments/assets/ef854ff1-07c7-4b66-a963-1a6416a72c61)

## Deploy do WordPress Usando Docker Compose
1. Finalizar o docker-compose.yml
Insira as configurações do banco de dados no arquivo docker-compose.yml:
```bash
yaml
Copiar código
version: '3.1'

services:
  wordpress:
    image: wordpress:latest
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: <endereço_do_banco>
      WORDPRESS_DB_USER: laura
      WORDPRESS_DB_PASSWORD: Helena0250!
      WORDPRESS_DB_NAME: bd-wordpress
    volumes:
      - ./wp-content:/var/www/html/wp-content
```

2. Iniciar o Container do WordPress
Execute o seguinte comando para iniciar o container:

```bash
docker-compose up -d
```

3. Verificar o Funcionamento
Verifique se o WordPress está acessível através do IP da instância EC2.

## Configuração do AWS EFS e Integração
1. Criar EFS na AWS
Crie um sistema de arquivos EFS na AWS e configure as permissões necessárias.
![image](https://github.com/user-attachments/assets/e940a3ed-530a-4ea4-a484-3a476149e4cc)


2. Montar o EFS na Instância EC2
Monte o EFS na sua instância EC2:

```bash
sudo mount -t nfs4 -o nfsvers=4.1 fs-<id_efs>.efs.<sua_região>.amazonaws.com:/ /mnt/efs
```
![image](https://github.com/user-attachments/assets/8dec4640-5434-450a-a363-d76c74dfc685)

3. Atualizar o docker-compose.yml
Atualize o arquivo para integrar o EFS como volume:

```bash
volumes:
  - /mnt/efs:/var/www/html/wp-content
```

4. Reiniciar o Container
Reinicie o container para aplicar as mudanças:

```bash
docker-compose down
docker-compose up -d
```
![image](https://github.com/user-attachments/assets/e84f40d7-e4bc-4d88-9a2d-3585ce0e5ef6)


## Configuração do Load Balancer e Testes Finais
1. Criar Load Balancer
No console da AWS, crie um Load Balancer e associe-o às instâncias EC2.

2. Configurar Regras de Segurança
Certifique-se de que o Load Balancer permite o tráfego HTTP nas portas 80 e 8080.
![image](https://github.com/user-attachments/assets/b4344f3b-024c-4e0b-8fda-8b6bf48be3f6)





