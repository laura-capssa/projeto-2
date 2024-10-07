#!/bin/bash
# Atualizar pacotes  que ja existem
sudo apt-get update -y

# Instalar pacotes  para usar o repositório  HTTPS
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Adicionar a chave GPG do Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Adicionar o repositório Docker às fontes do APT
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Atualizar a lista de pacotes novamente após adicionar o repositório Docker
sudo apt-get update -y

# Instalar o Docker
sudo apt-get install -y docker-ce

# Habilitar o Docker para iniciar automaticamente na inicialização
sudo systemctl enable docker

# Iniciar o serviço Docker
sudo systemctl start docker

# Verificar a instalação do Docker
sudo docker --version

# Criar uma mensagem de confirmação no arquivo de log
echo "Docker instalado e configurado com sucesso!" > /var/log/docker-install.log

