# itakitchen-com212
Sistema de avaliação de restaurantes de Itajubá.

Para rodar a api: python -m uvicorn webservice:app --reload

Recursos necessários:

Postgresql 12

Python 3

NVM

Node 14.18.1

Ionic 3.20.0

Fast API

Uvicorn

Psycopg2


# Instalação Windows

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

 # Iniciando o projeto no Windows:

Passo 1:Para a execução da aplicação acesse os arquivos do projeto, e na pasta “api” acesse o arquivo “webservice.py” e na linha 24 modifique o password para a senha utilizada na instalação do PostgreSQL e salve o arquivo.

Passo 2:Execute o PgAdmin, clique no botão “Servers”, no botão “PostgreSQL 12” e insira a senha usada para instalar o PostgreSQL. Clique no botão “Databases”, no botão “Object”, “Create”, “Database” e na janela que abrir e no campo “database” insira o nome “itakitchen” e então no botão “save”.

Passo3:Clique com o botão direito no nome do banco, clique em restore e na janela que abrir no filename localize o arquivo "backup.sql" na pasta "banco de dados" do projeto e clique em restore. 

Passo 3:Com o banco criado, clique no botão “PSQL Tool” e insira o comando: CREATE EXTENSION pgcrypto;. O banco está iniciado.

Passo 4:Abra um Prompt de Comando na pasta “api” do projeto e insira o comando >python -m uvicorn webservice:app --reload. Esse comando inicia a API.

Passo 5:Abra um Prompt de Comando na pasta “itakitchen” do projeto e insira o comando >ionic serve, pressione enter e logo em seguida digite “y” para baixar as dependências do projeto. Isso inicia a aplicação no navegador e está pronta para uso.
