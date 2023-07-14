<h1 align="center">
  <img src="https://github.com/ClaraNs/itakitchen-com212/assets/107441152/2a5d98df-9a33-48bf-a1ba-a439bfbf7ed7" alt="ItaKitchen" />
</h1>

<p align="center">
  <a href="https://www.postgresql.org/">
    <img src="http://img.shields.io/static/v1?label=PostgreSQL&message=12&color=blue&style=for-the-badge&logo=postgresql"/>
  </a>
  <a href="https://www.python.org/">
    <img src="http://img.shields.io/static/v1?label=Pyhton&message=3&color=green&style=for-the-badge&logo=python"/>
  </a>
  <a href="https://github.com/nvm-sh/nvm">
    <img src="http://img.shields.io/static/v1?label=NVM&message=Latest&color=yellow&style=for-the-badge&logo=nvm"/>
  </a>
  <a href="https://nodejs.org/">
    <img src="http://img.shields.io/static/v1?label=Node.js&message=14.18.1&color=green&style=for-the-badge&logo=node.js"/>
  </a>
  <a href="https://ionicframework.com/">
    <img src="http://img.shields.io/static/v1?label=Ionic&message=3.20.0&color=2D9CDB&style=for-the-badge&logo=ionic"/>
  </a>
  <a href="https://www.uvicorn.org/">
    <img src="http://img.shields.io/static/v1?label=Uvicorn&message=Latest&color=pink&style=for-the-badge&logo=uvicorn"/>
  </a>
  <a href="https://www.psycopg.org/">
    <img src="http://img.shields.io/static/v1?label=Psycopg2&message=Latest&color=blue&style=for-the-badge&logo=psycopg2"/>
  </a>
  <a href="https://code.visualstudio.com/">
    <img src="https://img.shields.io/badge/Visual%20Studio%20Code-1.80.0-007ACC?style=for-the-badge&logo=visual-studio-code" alt="Visual Studio Code">
  </a>
  <a href="https://angularjs.org/">
    <img src="https://img.shields.io/badge/Angular-5.2.11-red?style=for-the-badge&logo=angular" alt="AngularJS">
  </a>
</p>

<p align="center">
  O ItaKitchen é um sistema de avaliação e revisão de restaurantes localizados no município de Itajubá. O objetivo do projeto é fornecer aos usuários uma plataforma para escrever avaliações completas sobre estabelecimentos de alimentação, abrangendo diferentes aspectos, como ambiente, comida, atendimento e preço. O sistema visa ajudar os moradores locais, estudantes universitários e repúblicas a explorar e tomar decisões sobre as opções de refeições disponíveis em Itajubá.
</p>

# ✔️ Status de Desenvolvimento
<img src="http://img.shields.io/static/v1?label=STATUS&message=CONCLUIDO&color=GREEN&style=for-the-badge"/>


# :pushpin: Índice

* [Funcionalidades Principais](#funcionalidades-principais)
* [Demonstração](#demonstracao)
* [Acesso ao Projeto](#acesso-ao-projeto)
* [Tecnologias utilizadas](#tecnologias-utilizadas)
* [Pessoas Desenvolvedoras do Projeto](#pessoas-desenvolvedoras)



# ⚙️ Funcionalidades Principais

- Cadastro de Estabelecimentos: Os proprietários de restaurantes podem se cadastrar no sistema para terem seus estabelecimentos avaliados pelos usuários.

- Cadastro de Clientes: Os usuários podem criar contas no sistema para se tornarem clientes e terem acesso à funcionalidade de avaliação.

- Avaliação de Estabelecimentos: Os clientes podem avaliar os estabelecimentos cadastrados, fornecendo feedback sobre a comida, o ambiente, o atendimento e o preço.

- Pesquisa e Visualização de Avaliações: Os usuários podem pesquisar e visualizar avaliações de estabelecimentos específicos, ajudando-os a tomar decisões informadas sobre onde comer.

# Preparação do Ambiente no Linux

Linha de comando para instalar python3

>sudo apt install python3

Linha de comando para instalar NVM

>curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

Linha de comando para instalar node 14.18.1

>nvm install 14.18.1

Linha de comando para instalar o Ionic 3.20.0

>npm install -g ionic@3.20.0

Linha de comando para instalar o pip

>sudo apt install python3-pip

Linha de comando para instalar o fastapi

>pip install fastapi

Linha de comando para instalar o uvicorn

>pip install uvicorn

Linha de comando para instalar o psycopg2

>pip install psycopg2


# Preparação do Ambiente no Windows

Para instalar o PostgreSQL 12 e o PgAdmin acesse o link abaixo e realize a instalação. (Obs: Guardar a senha que colocar no installer pois utilizará ela futuramente)

https://www.enterprisedb.com/downloads/postgres-postgresql-downloads

Para Instalar o Python 3 acesse o link abaixo e realize a instalação.

https://www.python.org/downloads/

Para instalar o NVM para Windows acesse o link abaixo, localize a seção assets, clique no “nvm-setup.exe” e realize a instalação.

https://github.com/coreybutler/nvm-windows/releases

Para instalar o Node acesse o Prompt de Comando como administrador e insira o comando abaixo

>nvm install 14.18.1

OBS: Caso tenha alguma outra versão do Node instalada insira o comando abaixo para utilizar a versão correta do Node.

>nvm use 14.18.1

Para instalar o Ionic 3.20.0 insira o comando abaixo.

>npm install -g ionic@3.20.0

Para instalar o FastAPI insira o comando abaixo.

>pip install fastapi -U

Para instalar o Uvicorn insira o comando abaixo.

>pip install uvicorn

Para instalar o Psycopg2 insira o comando abaixo.

>pip install psycopg2

 # Iniciando o Projeto no Windows:

Passo 1: Para a execução da aplicação acesse os arquivos do projeto, e na pasta “api” acesse o arquivo “webservice.py” e na linha 24 modifique o password para a senha utilizada na instalação do PostgreSQL e salve o arquivo.

Passo 2: Execute o PgAdmin, clique no botão “Servers”, no botão “PostgreSQL 12” e insira a senha usada para instalar o PostgreSQL. Clique no botão “Databases”, no botão “Object”, “Create”, “Database” e na janela que abrir e no campo “database” insira o nome “itakitchen” e então no botão “save”.

Passo3: Clique com o botão direito no nome do banco, clique em restore e na janela que abrir no filename localize o arquivo "backup.sql" na pasta "banco de dados" do projeto e clique em restore. 

Passo 3: Com o banco criado, clique no botão “PSQL Tool” e insira o comando: CREATE EXTENSION pgcrypto;. O banco está iniciado.

Passo 4: Abra um Prompt de Comando na pasta “api” do projeto e insira o comando >python -m uvicorn webservice:app --reload. Esse comando inicia a API.

Passo 5: Abra um Prompt de Comando na pasta “itakitchen” do projeto e insira o comando >ionic serve, pressione enter e logo em seguida digite “y” para baixar as dependências do projeto. Isso inicia a aplicação no navegador e está pronta para uso.


Para rodar a api: 
> python -m uvicorn webservice:app --reload
