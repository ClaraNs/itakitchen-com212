#python -m uvicorn webservice:app --reload

from fastapi import FastAPI
import psycopg2
import model
import base64 
from datetime import datetime

from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


conexao = "host='localhost' dbname='itakitchen' user='postgres' password='lulu'"


def image_to_base64(image_path):
    with open(image_path, "rb") as image_file:
        image_data = image_file.read()
        base64_data = base64.b64encode(image_data)
        base64_string = base64_data.decode("utf-8")
        return base64_string

image_path = "padrao.png"
img_padrao_estab = image_to_base64(image_path)
image_path = "padraocliente.png"
img_padrao_cliente = image_to_base64(image_path)


def ret(query):
        try:
            conn = psycopg2.connect(conexao)
        except Exception as e:
            raise e

        try:
            cur = conn.cursor()
            cur.execute(query)
            return cur.fetchall()
        except Exception as e:
            conn.rollback()
            print(e)
            return e
        finally:
            cur.close()
            conn.close()
            
def retByValue(query, values = None):
        try:
            conn = psycopg2.connect(conexao)
        except Exception as e:
            raise e

        try:
            cur = conn.cursor()
            cur.execute(query, (values))
            return cur.fetchall()
        except Exception as e:
            conn.rollback()
            print(e)
            return e
        finally:
            cur.close()
            conn.close()
            
def alter(query, values):
        try:
            conn = psycopg2.connect(conexao)
        except Exception as e:
            print(e)
            raise e

        try:
            cur = conn.cursor()
            cur.execute(query, values)
            conn.commit()
            return "Sucesso"
        except Exception as e:
            conn.rollback()
            print(e)
            return e
        finally:
            cur.close()
            conn.close()

#CRUD das tabelas

#Cliente

def bytea_to_base64(bytea):
    # Converter o objeto bytea para bytes
    bytes_data = bytes(bytea)

    # Codificar os bytes em uma string base64
    base64_string = base64.b64encode(bytes_data).decode('utf-8')

    return base64_string

@app.post("/login")
def fazLogin(item: dict):
    
    retorno = retByValue("SELECT c.id, c.email, c.nome, c.cpf, c.dataNascimento, c.foto, c.tipo FROM cliente as c WHERE c.email = %s AND c.senha = crypt(%s, c.senha)",
                         (item["email"], item["senha"],))
    result = []
    
    # Nao existe cliente com aquele email, tenta estabelecimento
    if retorno == []:
        retorno = retByValue("SELECT e.id, e.nome, e.cnpj, e.email, e.contato, e.foto, e.descricao, e.idEndereco, e.idHorarioFunc, e.idCategoria FROM estabelecimento as e WHERE e.email = %s AND e.senha = crypt(%s, e.senha)",
                         (item["email"], item["senha"],))
        for idn, nome, cnpj, email, contato, foto, descricao, endereco, horario, categoria in retorno:
            if descricao == None:
                descricao = ""
            if(foto != None):
                fotocerta = bytea_to_base64(foto)
                print(foto)
                result.append(model.Estabelecimento(idn, nome, cnpj, email, contato, str(fotocerta), descricao, endereco, horario, categoria))
            else:
                result.append(model.Estabelecimento(idn, nome, cnpj, email, contato, None, descricao, endereco, horario, categoria))
    else:
        for idn, email, nome, cpf, datanas, foto, tipo in retorno:
            if(foto != None):
                fotocerta = bytea_to_base64(foto)
                result.append(model.Cliente(idn, email, nome, cpf, datanas, str(fotocerta), tipo))
            else:
                result.append(model.Cliente(idn, email, nome, cpf, datanas, None, tipo))

    if result == []:
        return 0
    else:
        return result


@app.get("/clienteporcpf&cpf={cpf}")
def retornaClienteCpf(cpf):
    
    retorno = retByValue("SELECT COUNT(c.id) FROM cliente as c WHERE c.cpf = %s", (cpf,))
    print(retorno)
    return retorno

@app.get("/cliente")
def retornaCliente():
    
    
    retorno = ret("SELECT c.id, c.email, c.nome, c.cpf, c.dataNascimento, c.foto, c.tipo FROM cliente as c")

    result = []
    for id, email, nome, cpf, datanas, foto, tipo in retorno:
        print(foto)
        if foto is None:
            fotocerta = ""
        else:
            fotocerta = bytea_to_base64(foto)
        result.append(model.Cliente(id, email, nome, cpf, datanas, str(fotocerta), tipo))
    
    return result

@app.get("/cliente&id={id}")
def retornaClientePorId(id):
    
    retorno = retByValue("SELECT c.id, c.email, c.nome, c.cpf, c.dataNascimento, c.foto, c.tipo FROM cliente as c WHERE c.id = %s", (id,))

    result = []
    for idn, email, nome, cpf, datanas, foto, tipo in retorno:
        if foto is None:
            fotocerta = ""
        else:
            fotocerta = bytea_to_base64(foto)      
        result.append(model.Cliente(idn, email, nome, cpf, datanas, str(fotocerta), tipo))
    
    return result

@app.post("/criarcliente")
def criaCliente(item: dict):
    
    prefoto = img_padrao_cliente
    if "foto" in item and item["foto"] != None:
        prefoto = item["foto"]
        
    
    base64_string = prefoto
    if prefoto.startswith('data:image'):
        base64_string = prefoto.split(',', 1)[1]

    # Decodificar a string base64 em bytes
    decoded_bytes = base64.b64decode(base64_string)

    # Converter os bytes para o tipo de dados bytearray
    bytea = bytearray(decoded_bytes)
    foto = bytea
    
    print(foto)

    now = datetime.now()
    dataCriacao = now.strftime("%Y-%m-%d %H:%M:%S")
    
    retorno = alter("INSERT INTO cliente (email, nome, senha, cpf, dataNascimento, foto, tipo, dataeHoraCriacao)"+ 
                    "VALUES (%s, %s, crypt(%s, gen_salt('bf')), %s, %s, %s, %s, %s)", (item["email"], item["nome"], item["senha"], item["cpf"], item["datanas"], foto, item["tipo"], dataCriacao))

    if(retorno == 'Sucesso'):
        result = 1
    else:
        result = 0

    return result

@app.delete("/deletacliente&id={id}")
def deletaCliente(id):
    
    retorno = alter("DELETE FROM cliente WHERE id = %s", (id,))

    if(retorno == 'Sucesso'):
        result = 1
    else:
        result = 0
    
    return result

@app.put("/atualizacliente&id={id}&campos={campos}&valores={valores}")
def atualizaCliente(id, campos, valores):
    
    print(tuple(campos.split(",")))
    campos = campos.split(",")
    campos.pop()
    campos = tuple(campos)
    valores = valores.split("!")
    valores.pop()
    valores = tuple(valores)
    
    
    stratt = ""
    for i in range(len(campos)):
        if(stratt != ''):
            stratt += ", " + campos[i] + " = %s"
        else:
            stratt += campos[i] + " = %s"
            
    valores += (id,)
    print(stratt)
    
    retorno = alter("UPDATE cliente SET "+ stratt + " WHERE id = %s", valores)

    if(retorno == 'Sucesso'):
        result = 1
    else:
        result = 0
    
    return result

@app.get("/numavaliacoescliente&id={id}")
def retornaNumAvaliacoes(id):
    
    retorno = retByValue("SELECT count(*) FROM avaliacao as a WHERE a.idcli = %s", (id,))

    result = []
    for valor in retorno:
        result.append(valor)
    
    return result

# Retorna os 5 clientes com mais avaliações feitas na plataforma (nome e total de avaliações)
@app.get("/clientesmaisativos")
def clientesMaisAtivos():
    
    retorno = retByValue("SELECT c.nome, COUNT(a.idCli) AS total_avaliacoes "
                        "FROM cliente AS c "
                        "JOIN avaliacao AS a ON a.idCli = c.id "
                        "GROUP BY c.nome "
                        "ORDER BY total_avaliacoes DESC "
                        "LIMIT 5")

    result = []
    for nome, total_avaliacoes in retorno:
        result.append((nome, total_avaliacoes))
    
    return result

#Estabelecimento 
@app.get("/usuarioporemail&email={email}")
def retornaUsuarioEmail(email):
    
    retorno = retByValue( "SELECT COUNT(*) AS total FROM ("
                         "SELECT 'estabelecimento' AS email FROM estabelecimento WHERE email = %s "
                         "UNION ALL "
                         "SELECT 'cliente' AS email FROM cliente WHERE email = %s "
                         ") AS combined", (email, email))

    print(retorno)
    return retorno



@app.get("/estabelecimentoporcnpj&cnpj={cnpj}")
def retornaEstabelecimentoCnpj(cnpj):
    
    retorno = retByValue("SELECT COUNT(e.id) FROM estabelecimento as e WHERE e.cnpj = %s", (cnpj,))
    print(retorno)
    return retorno

@app.get("/estabelecimentopornome&pesquisa={pesquisa}")
def retornaEstabelecimentoPorNome(pesquisa):
    
    pesquisa = pesquisa + '%'
    retorno = retByValue("SELECT e.id, e.nome, e.cnpj, e.email, e.contato, e.foto, e.descricao," +
                  "e.idendereco, e.idhorariofunc, e.idcategoria FROM estabelecimento as e WHERE e.nome ilike %s", (pesquisa,))
    print(retorno)
    result = []
    for id, nome, cnpj, email, contato, foto, descricao, idendereco, idhorariofunc, idcategoria in retorno:
        if foto is None:
            fotocerta = ""
        else:
            fotocerta = bytea_to_base64(foto)

        if "descricao" == None:
            descricao = ""
            
        result.append(model.Estabelecimento(id, nome, cnpj, email, contato, str(fotocerta), descricao, idendereco, idhorariofunc, idcategoria))
    
    return result

@app.get("/estabelecimento")
def retornaEstabelecimento():
    
    
    retorno = ret("SELECT e.id, e.nome, e.cnpj, e.email, e.contato, e.foto, e.descricao," +
                  "e.idendereco, e.idhorariofunc, e.idcategoria FROM estabelecimento as e order by e.nome")

    result = []
    for id, nome, cnpj, email, contato, foto, descricao, idendereco, idhorariofunc, idcategoria in retorno:
        if foto is None:
            fotocerta = ""
        else:
            fotocerta = bytea_to_base64(foto)

        if "descricao" == None:
            descricao = ""
            
        result.append(model.Estabelecimento(id, nome, cnpj, email, contato, str(fotocerta), descricao, idendereco, idhorariofunc, idcategoria))
    
    return result

@app.get("/estabelecimento&id={id}")
def retornaEstabelecimentoPorId(id):
    
    retorno = retByValue("SELECT e.id, e.nome, e.cnpj, e.email, e.contato, e.foto, e.descricao, " +
                  "e.idendereco, e.idhorariofunc, e.idcategoria FROM estabelecimento as e WHERE e.id = %s", (id,))

    result = []
    print(retorno)
    for idn, nome, cnpj, email, contato, foto, descricao, idendereco, idhorariofunc, idcategoria in retorno:
        if foto is None:
            fotocerta = ""
        else:
            fotocerta = bytea_to_base64(foto)
        result.append(model.Estabelecimento(idn, nome, cnpj, email, contato, str(fotocerta), descricao, idendereco, idhorariofunc, idcategoria))
    
    return result

@app.post("/criarestabelecimento")
def criarEstabelecimento(item: dict):
    # Atributos não obrigatórios
    prefoto = img_padrao_estab
    print(item)
    if "foto" in item and item["foto"] != None:
        prefoto = item["foto"]
        
    base64_string = prefoto
    if prefoto.startswith('data:image'):
        base64_string = prefoto.split(',', 1)[1]

    # Decodificar a string base64 em bytes
    decoded_bytes = base64.b64decode(base64_string)

    # Converter os bytes para o tipo de dados bytearray
    bytea = bytearray(decoded_bytes)
    foto = bytea
    
    if "descricao" in item:
        descricao = item["descricao"]
    else:
        descricao = None
    
    if "complem" in item:
        complemento = item["complem"]
    else:
        complemento = None

    retorno = alter("CALL inserir_estabelecimento(%s, %s, %s, crypt(%s, gen_salt('bf')), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
                (item["nome"], item["cnpj"], item["email"], item["senha"], item["contato"], foto, descricao, item["rua"], item["numero"], complemento, item["bairro"], item["cep"], item["hdomingoinicio"], item["hdomingofim"], item["hsegundainicio"], item["hsegundafim"], item["htercainicio"], item["htercafim"], item["hquartainicio"], item["hquartafim"], item["hquintainicio"], item["hquintafim"], item["hsextainicio"], item["hsextafim"], item["hsabadoinicio"], item["hsabadofim"], item["categoria"]))
    
    if(retorno == 'Sucesso'):
        result = 1
    else:
        result = 0

    return result


@app.delete("/deletaestabelecimento&id={id}")
def deletaEstabelecimento(id):
    
    retorno = alter("DELETE FROM estabelecimento WHERE id = %s", (id,))

    if(retorno == 'Sucesso'):
        result = 1
    else:
        result = 0
    
    return result

@app.put("/atualizaestabelecimento&id={id}&campos={campos}&valores={valores}")
def atualizaEstabelecimento(id, campos, valores):
    
    print(tuple(campos.split(",")))
    campos = tuple(campos.split(","))
    valores = tuple(valores.split(","))
    
    stratt = ""
    for i in range(len(campos)):
        if(stratt != ""):
            stratt += ", " + campos[i] + " = %s"
        else:
            stratt += campos[i] + " = %s"
            
    valores += (id,)
    print(stratt)
    
    retorno = alter("UPDATE estabelecimento SET "+ stratt + " WHERE id = %s", valores)

    if(retorno == 'Sucesso'):
        result = 1
    else:
        result = 0
    
    return result

# Consulta por categoria
@app.get("/estabelecimentoporcategoria&categoria={categoria}")
def estabelecimentoPorCategoria(categoria):

    retorno = retByValue("SELECT e.id, e.nome, e.cnpj, e.email, e.contato, e.foto, e.descricao, " +
                  "e.idendereco, e.idhorariofunc, e.idcategoria FROM estabelecimento as e " +  
                  "JOIN categoria AS c ON e.idcategoria = c.id WHERE c.descricao = %s", (categoria,))

    result = []
    for idn, nome, cnpj, email, contato, foto, descricao, idendereco, idhorariofunc, idcategoria in retorno:
        if foto is None:
            fotocerta = ""
        else:
            fotocerta = bytea_to_base64(foto)
        result.append(model.Estabelecimento(idn, nome, cnpj, email, contato, str(fotocerta), descricao, idendereco, idhorariofunc, idcategoria))
    
    return result

# Consulta por nome
@app.get("/estabelecimentopornome&nome={nome}")
def estabelecimentoPorNomeInteiro(nome):

    retorno = retByValue("SELECT e.id, e.nome, e.cnpj, e.email, e.contato, e.foto, e.descricao, " +
                  "e.idendereco, e.idhorariofunc, e.idcategoria FROM estabelecimento as e " +  
                  "WHERE e.nome LIKE %s", ('%' + nome + '%',))

    result = []
    for idn, nome, cnpj, email, contato, foto, descricao, idendereco, idhorariofunc, idcategoria in retorno:
        if foto is None:
            fotocerta = ""
        else:
            fotocerta = bytea_to_base64(foto)
        result.append(model.Estabelecimento(idn, nome, cnpj, email, contato, str(fotocerta), descricao, idendereco, idhorariofunc, idcategoria))
    
    return result

#Endereço
@app.get("/endereco")
def retornaEndereco():
    
    
    retorno = ret("SELECT e.id, e.rua, e.numero, e.complem, e.bairro, e.cep FROM endereco as e")

    result = []
    for id, rua, numero, complem, bairro, cep in retorno:
        result.append(model.Endereco(id, rua, numero, complem, bairro, cep))
    
    return result

@app.get("/endereco&id={id}")
def retornaEnderecoPorId(id):
    
    retorno = retByValue("SELECT e.id, e.rua, e.numero, e.complem, e.bairro, e.cep FROM endereco as e WHERE e.id = %s", (id,))

    result = []
    for idn, rua, numero, complem, bairro, cep in retorno:
        result.append(model.Endereco(idn, rua, numero, complem, bairro, cep))
    
    return result


@app.put("/atualizaendereco&id={id}&campos={campos}&valores={valores}")
def atualizaEndereco(id, campos, valores):
    
    print(tuple(campos.split(",")))
    campos = tuple(campos.split(","))
    valores = tuple(valores.split(","))
    
    stratt = ""
    for i in range(len(campos)):
        if(stratt != ""):
            stratt += ", " + campos[i] + " = %s"
        else:
            stratt += campos[i] + " = %s"
            
    valores += (id,)
    print(stratt)
    
    retorno = alter("UPDATE endereco SET "+ stratt + " WHERE id = %s", valores)

    if(retorno == 'Sucesso'):
        result = 1
    else:
        result = 0
    
    return result

#Horario de Funcionamento
@app.get("/horario")
def retornaHorario():
    
    
    retorno = ret("SELECT h.id, h.hdomingoinicio, h.hdomingofim, h.hsegundainicio, h.hsegundafim, " + 
                      "h.htercainicio, h.htercafim, h.hquartainicio, h.hquartafim, " + 
                      "h.hquintainicio, h.hquintafim, h.hsextainicio, h.hsextafim, " + 
                      "h.hsabadoinicio, h.hsabadofim FROM horariofuncionamento as h")
    
    result = []
    for id, hDomingoInicio, hDomingoFim, hSegundaInicio, hSegundaFim, hTercaInicio, hTercaFim, hQuartaInicio, hQuartaFim, hQuintaInicio, hQuintaFim, hSextaInicio, hSextaFim, hSabadoInicio, hSabadoFim in retorno:
        result.append(model.HorarioFuncionamento(id, hDomingoInicio, hDomingoFim, hSegundaInicio, hSegundaFim, hTercaInicio, hTercaFim, hQuartaInicio, hQuartaFim, hQuintaInicio, hQuintaFim, hSextaInicio, hSextaFim, hSabadoInicio, hSabadoFim));
    
    return result

@app.get("/horario&id={id}")
def retornaHorarioPorId(id):
    
    retorno = retByValue("SELECT h.id, h.hdomingoinicio, h.hdomingofim, h.hsegundainicio, h.hsegundafim, " + 
                      "h.htercainicio, h.htercafim, h.hquartainicio, h.hquartafim, " + 
                      "h.hquintainicio, h.hquintafim, h.hsextainicio, h.hsextafim, " + 
                      "h.hsabadoinicio, h.hsabadofim FROM horariofuncionamento as h WHERE h.id = %s", (id,))

    result = []
    for idn, hDomingoInicio, hDomingoFim, hSegundaInicio, hSegundaFim, hTercaInicio, hTercaFim, hQuartaInicio, hQuartaFim, hQuintaInicio, hQuintaFim, hSextaInicio, hSextaFim, hSabadoInicio, hSabadoFim in retorno:
        result.append(model.HorarioFuncionamento(idn, hDomingoInicio, hDomingoFim, hSegundaInicio, hSegundaFim, hTercaInicio, hTercaFim, hQuartaInicio, hQuartaFim, hQuintaInicio, hQuintaFim, hSextaInicio, hSextaFim, hSabadoInicio, hSabadoFim));
    
    return result



@app.put("/atualizahorario&id={id}&campos={campos}&valores={valores}")
def atualizaHorario(id, campos, valores):
    
    print(tuple(campos.split(",")))
    campos = tuple(campos.split(","))
    valores = tuple(valores.split(","))
    
    stratt = ""
    for i in range(len(campos)):
        if(stratt != ""):
            stratt += ", " + campos[i] + " = %s"
        else:
            stratt += campos[i] + " = %s"
            
    valores += (id,)
    print(stratt)
    
    retorno = alter("UPDATE horariofuncionamento SET "+ stratt + " WHERE id = %s", valores)

    if(retorno == 'Sucesso'):
        result = 1
    else:
        result = 0
    
    return result

#Avaliação
@app.get("/avaliacao")
def retornaAvaliacao():
    
    
    retorno = ret("SELECT a.id, a.idcli, a.idestab, a.media, a.notarefeicao, a.descrirefeicao, a.notaatendimento, a.descriatendimento, " +
                  " a.notaambiente, a.descriambiente, a.notapreco, a.descripreco, a.dataehora FROM avaliacao as a order by a.dataehora desc")

    result = []
    for (id, idCli, idEstab, media, notaRefeicao, descriRefeicao,
                 notaAtendimento, descriAtendimento,
                 notaAmbiente, descriAmbiente,
                 notaPreco, descriPreco,
                 dataeHora) in retorno:
        result.append(model.Avaliacao(id, idCli, idEstab, round(media,2), notaRefeicao, descriRefeicao,
                                      notaAtendimento, descriAtendimento, notaAmbiente, descriAmbiente,
                                      notaPreco, descriPreco, dataeHora))
    
    return result

@app.get("/avaliacao&id={id}")
def retornaAvaliacaoPorId(id):
    
    retorno = retByValue("SELECT a.id, a.idcli, a.idestab, a.media, a.notarefeicao, a.descrirefeicao, a.notaatendimento, a.descriatendimento, " +
                  " a.notaambiente, a.descriambiente, a.notapreco, a.descripreco, a.dataehora FROM avaliacao as a WHERE a.id = %s", (id,))

    result = []
    for (id, idCli, idEstab, media, notaRefeicao, descriRefeicao,
                 notaAtendimento, descriAtendimento,
                 notaAmbiente, descriAmbiente,
                 notaPreco, descriPreco,
                 dataeHora) in retorno:
        result.append(model.Avaliacao(id, idCli, idEstab, round(media,2), notaRefeicao, descriRefeicao,
                                      notaAtendimento, descriAtendimento, notaAmbiente, descriAmbiente,
                                      notaPreco, descriPreco, dataeHora))
    return result

# Avaliações do cliente com aquele id
@app.get("/avaliacaocliente&id={id}")
def retornaAvaliacaoPorCliente(id):
    
    retorno = retByValue("SELECT a.id, a.idcli, a.idestab, a.media, a.notarefeicao, a.descrirefeicao, a.notaatendimento, a.descriatendimento, " +
                  " a.notaambiente, a.descriambiente, a.notapreco, a.descripreco, a.dataehora FROM avaliacao as a WHERE a.idcli = %s order by a.dataehora desc", (id,))

    result = []
    for (id, idCli, idEstab, media, notaRefeicao, descriRefeicao,
                 notaAtendimento, descriAtendimento,
                 notaAmbiente, descriAmbiente,
                 notaPreco, descriPreco,
                 dataeHora) in retorno:
        result.append(model.Avaliacao(id, idCli, idEstab, round(media,2), notaRefeicao, descriRefeicao,
                                      notaAtendimento, descriAtendimento, notaAmbiente, descriAmbiente,
                                      notaPreco, descriPreco, dataeHora))
    return result

@app.get("/numavaliacaoporestab&id={id}")
def retornaNotaENumAvaliacoesPorEstab(id):
    
    retorno = retByValue("SELECT COUNT(*), AVG(a.media) FROM avaliacao as a WHERE a.idestab = %s", (id,))

    result = []
    for num, media in retorno:
        if(media == None):
            result.append([num, 0])
        else:
            result.append([num, round(media,2)])
    return result

@app.get("/avaliacaoporestab&id={id}")
def retornaAvaliacoesPorEstab(id):
    
    retorno = retByValue("SELECT a.id, a.idcli, a.idestab, a.media, a.notarefeicao, a.descrirefeicao, a.notaatendimento, a.descriatendimento, " +
                  " a.notaambiente, a.descriambiente, a.notapreco, a.descripreco, a.dataehora FROM avaliacao as a WHERE a.idestab = %s order by a.dataehora desc", (id,))

    result = []
    for (idn, idCli, idEstab, media, notaRefeicao, descriRefeicao,
                 notaAtendimento, descriAtendimento,
                 notaAmbiente, descriAmbiente,
                 notaPreco, descriPreco,
                 dataeHora) in retorno:
        result.append(model.Avaliacao(idn, idCli, idEstab, round(media,2), notaRefeicao, descriRefeicao,
                                      notaAtendimento, descriAtendimento, notaAmbiente, descriAmbiente,
                                      notaPreco, descriPreco, dataeHora))
    return result

#Retorna os 5 estabelecimentos com maior média nas avaliacoes
@app.get("/estabelecimentomaisbemavaliado")
def retornaAvaliacoesPorEstab():
    
    retorno = retByValue("""
                        SELECT e.nome, sub.media 
                        FROM (
                            SELECT AVG(a.media) AS media, a.idEstab
                            FROM avaliacao AS a
                            GROUP BY a.idEstab
                            ORDER BY AVG(a.media) DESC
                            LIMIT 5
                        ) AS sub
                        JOIN estabelecimento AS e ON sub.idEstab = e.id ORDER BY sub.media desc;
                        """)

    result = []
    for (nome, media) in retorno:
        result.append((nome, round(float(media),2)))
    return result

@app.post("/criaravaliacao")
def criaAvaliacao(item: dict):
    now = datetime.now()
    dataCriacao = now.strftime("%Y-%m-%d %H:%M:%S")

    if "descrirefeicao" in item:
        des_refeicao = item["descrirefeicao"]
    else:
        des_refeicao = None
    
    if "descriatendimento" in item:
        des_atendi = item["descriatendimento"]
    else:
        des_atendi = None
    
    if "descriambiente" in item:
        des_amb = item["descriambiente"]
    else:
        des_amb = None

    if "descripreco" in item:
        des_pre = item["descripreco"]
    else:
        des_pre = None

    retorno = alter("CALL inserir_avaliacao(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
                (item["idcli"], item["idestab"], item["notarefeicao"], des_refeicao, item["notaatendimento"], des_atendi, item["notaambiente"], des_amb, item["notapreco"], des_pre, dataCriacao))
    
    if(retorno == 'Sucesso'):
        result = 1
    else:
        result = 0
    
    return result


@app.delete("/deletaavaliacao&id={id}")
def deletaAvaliacao(id):
    
    retorno = alter("DELETE FROM avaliacao WHERE id = %s", (id,))

    if(retorno == 'Sucesso'):
        result = 1
    else:
        result = 0
    
    return result

@app.put("/atualizaavaliacao&id={id}&campos={campos}&valores={valores}")
def atualizaAvaliacao(id, campos, valores):
    
    print(tuple(campos.split(",")))
    campos = tuple(campos.split(","))
    valores = tuple(valores.split(","))
    
    stratt = ""
    for i in range(len(campos)):
        if(stratt != ""):
            stratt += ", " + campos[i] + " = %s"
        else:
            stratt += campos[i] + " = %s"
            
    valores += (id,)
    print(stratt)
    
    retorno = alter("UPDATE avaliacao SET "+ stratt + " WHERE id = %s", valores)

    if(retorno == 'Sucesso'):
        result = 1
    else:
        result = 0
    
    return result

#Categoria
@app.get("/categoria")
def retornaCategoria():
    
    
    retorno = ret("SELECT c.id, c.descricao FROM categoria as c ORDER BY c.descricao")

    result = []
    for (id, descricao) in retorno:
        result.append(model.Categoria(id, descricao))
    
    return result

@app.get("/categoria&id={id}")
def retornaAvaliacaoPorId(id):
    
    retorno = retByValue("SELECT c.id, c.descricao FROM categoria as c WHERE c.id = %s", (id,))

    result = []
    for (idn, descricao) in retorno:
        result.append(model.Categoria(idn, descricao))
    return result
