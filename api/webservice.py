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

conexao = psycopg2.connect(
    host="localhost",
    database="itakitchen",
    user="postgres",
    password="lulu")

def ret(query):
        try:
            conn = conexao
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
            conn = conexao
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
            conn = conexao
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

@app.post("/login")
def fazLogin(item: dict):
    
    retorno = retByValue("SELECT c.id, c.email, c.nome, c.cpf, c.dataNascimento, c.foto, c.tipo FROM cliente as c WHERE c.email = %s AND c.senha = crypt(%s, c.senha)",
                         (item["email"], item["senha"],))
    result = []
    
    # Nao existe cliente com aquele email, tenta estabelecimento
    if retorno == []:
        retorno = retByValue("SELECT e.id, e.nome, e.cnpj, e.email, e.contato, e.foto, e.idEndereco, e.idHorarioFunc, e.idCategoria FROM estabelecimento as e WHERE e.email = %s AND e.senha = crypt(%s, e.senha)",
                         (item["email"], item["senha"],))
        for idn, nome, cnpj, email, contato, foto, endereco, horario, categoria in retorno:
            if(foto != None):
                result.append(model.Estabelecimento(idn, nome, cnpj, email, contato, str(bytes(foto)), endereco, horario, categoria))
            else:
                result.append(model.Estabelecimento(idn, nome, cnpj, email, contato, None, endereco, horario, categoria))
    else:
        for idn, email, nome, cpf, datanas, foto, tipo in retorno:
            if(foto != None):
                result.append(model.Cliente(idn, email, nome, cpf, datanas, str(bytes(foto)), tipo))
            else:
                result.append(model.Cliente(idn, email, nome, cpf, datanas, None, tipo))

    if result == []:
        return {"message": f"Nenhum usuário cadastrado com o email e senha informado"}
    else:
        return result


@app.get("/cliente")
def retornaCliente():
    
    
    retorno = ret("SELECT c.id, c.email, c.nome, c.cpf, c.dataNascimento, c.foto, c.tipo FROM cliente as c")

    result = []
    for id, email, nome, cpf, datanas, foto, tipo in retorno:
        print(foto)
        if(foto != None):
            result.append(model.Cliente(id, email, nome, cpf, datanas, str(bytes(foto)), tipo))
        else:
            result.append(model.Cliente(id, email, nome, cpf, datanas, None, tipo))
    
    return result

@app.get("/cliente&id={id}")
def retornaClientePorId(id):
    
    retorno = retByValue("SELECT c.id, c.email, c.nome, c.cpf, c.dataNascimento, c.foto, c.tipo FROM cliente as c WHERE c.id = %s", (id,))

    result = []
    for idn, email, nome, cpf, datanas, foto, tipo in retorno:
        result.append(model.Cliente(idn, email, nome, cpf, datanas, str(bytes(foto)), tipo))
    
    return result

@app.post("/criarcliente")
def criaCliente(item: dict):
    
    if "foto" in item and item["foto"] != None:
        base64_image = item["foto"]
        missing_padding = len(base64_image) % 4

        if missing_padding != 0:
            base64_image += '=' * (4 - missing_padding)

        foto = base64.urlsafe_b64decode(base64_image)
    else:
        foto = None

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
    
    retorno = alter("UPDATE cliente SET "+ stratt + " WHERE id = %s", valores)

    if(retorno == 'Sucesso'):
        result = 1
    else:
        result = 0
    
    return result

#Estabelecimento 
@app.get("/estabelecimento")
def retornaEstabelecimento():
    
    
    retorno = ret("SELECT e.id, e.nome, e.cnpj, e.email, e.contato, e.foto, " +
                  "e.idendereco, e.idhorariofunc, e.idcategoria FROM estabelecimento as e")

    result = []
    for id, nome, cnpj, email, contato, foto, idendereco, idhorariofunc, idcategoria in retorno:
        if foto is None:
            foto = ""
        else:
            foto = str(bytes(foto))
        result.append(model.Estabelecimento(id, nome, cnpj, email, contato, foto, idendereco, idhorariofunc, idcategoria))
    
    return result

@app.get("/estabelecimento&id={id}")
def retornaEstabelecimentoPorId(id):
    
    retorno = retByValue("SELECT e.id, e.nome, e.cnpj, e.email, e.contato, e.foto, " +
                  "e.idendereco, e.idhorariofunc, e.idcategoria FROM estabelecimento as e WHERE e.id = %s", (id,))

    result = []
    for idn, nome, cnpj, email, contato, foto, idendereco, idhorariofunc, idcategoria in retorno:
        if foto is None:
            foto = ""
        else:
            foto = str(bytes(foto))
        result.append(model.Estabelecimento(idn, nome, cnpj, email, contato, foto, idendereco, idhorariofunc, idcategoria))
    
    return result

@app.post("/criarestabelecimento")
def criarEstabelecimento(item: dict):
    # Atributos não obrigatórios
    if "foto" in item:
        base64_image = item["foto"]
        missing_padding = len(base64_image) % 4

        if missing_padding != 0:
            base64_image += '=' * (4 - missing_padding)

        foto = base64.urlsafe_b64decode(base64_image)
    else:
        foto = None
    
    if "descricao" in item:
        descricao = item["descricao"]
    else:
        descricao = None
    
    if "complem" in item:
        complemento = item["complem"]
    else:
        complemento = None

    retorno = alter("CALL inserir_estabelecimento(%s, %s, %s, crypt(%s, gen_salt('bf')), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
                (item["nome"], item["cnpj"], item["email"], item["senha"], item["contato"], foto, descricao,item["rua"], item["numero"], complemento, item["bairro"], item["cep"], item["hdomingoinicio"], item["hdomingofim"], item["hsegundainicio"], item["hsegundafim"], item["htercainicio"], item["htercafim"], item["hquartainicio"], item["hquartafim"], item["hquintainicio"], item["hquintafim"], item["hsextainicio"], item["hsextafim"], item["hsabadoinicio"], item["hsabadofim"], item["categoria"]))
    
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
    
    retorno = retByValue("SELECT e.id, e.rua, e.numero, e.complem, e.bairro, e.cep FROM endereco as e WHERE c.id = %s", (id,))

    result = []
    for idn, rua, numero, complem, bairro, cep in retorno:
        result.append(model.Endereco(idn, rua, numero, complem, bairro, cep))
    
    return result



@app.post("/criarendereco")
def criaEndereco(item: dict):
    
    retorno = alter("INSERT INTO endereco (rua, numero, complem, bairro, cep)"+ 
                    "VALUES (%s, %s, %s, %s, %s)", (item["rua"], item["numero"], item["complem"], item["bairro"], item["cep"]))

    if(retorno == 'Sucesso'):
        result = 1
    else:
        result = 0
    
    return result

@app.delete("/deletaendereco&id={id}")
def deletaEndereco(id):
    
    retorno = alter("DELETE FROM endereco WHERE id = %s", (id,))

    if(retorno == 'Sucesso'):
        result = 1
    else:
        result = 0
    
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
    
    
    retorno = ret("SELECT h.id, h.hdomingoinicio, h.hdomingofim, h.hsegundainicio, h.hsegundafim " + 
                      "SELECT h.htercainicio, h.htercafim, h.hquartainicio, h.hquartafim " + 
                      "SELECT h.hquintainicio, h.hquintafim, h.hsextainicio, h.hsextafim " + 
                      "h.hsabadoinicio, h.hsabadofim FROM horariofuncionamento as h")
    
    result = []
    for id, hDomingoInicio, hDomingoFim, hSegundaInicio, hSegundaFim, hTercaInicio, hTercaFim, hQuartaInicio, hQuartaFim, hQuintaInicio, hQuintaFim, hSextaInicio, hSextaFim, hSabadoInicio, hSabadoFim in retorno:
        result.append(model.HorarioFuncionamento(id, hDomingoInicio, hDomingoFim, hSegundaInicio, hSegundaFim, hTercaInicio, hTercaFim, hQuartaInicio, hQuartaFim, hQuintaInicio, hQuintaFim, hSextaInicio, hSextaFim, hSabadoInicio, hSabadoFim));
    
    return result

@app.get("/horario&id={id}")
def retornaHorarioPorId(id):
    
    retorno = retByValue("SELECT h.id, h.hdomingoinicio, h.hdomingofim, h.hsegundainicio, h.hsegundafim " + 
                      "SELECT h.htercainicio, h.htercafim, h.hquartainicio, h.hquartafim " + 
                      "SELECT h.hquintainicio, h.hquintafim, h.hsextainicio, h.hsextafim " + 
                      "h.hsabadoinicio, h.hsabadofim FROM horariofuncionamento as h WHERE h.id = %s", (id,))

    result = []
    for idn, hDomingoInicio, hDomingoFim, hSegundaInicio, hSegundaFim, hTercaInicio, hTercaFim, hQuartaInicio, hQuartaFim, hQuintaInicio, hQuintaFim, hSextaInicio, hSextaFim, hSabadoInicio, hSabadoFim in retorno:
        result.append(model.HorarioFuncionamento(idn, hDomingoInicio, hDomingoFim, hSegundaInicio, hSegundaFim, hTercaInicio, hTercaFim, hQuartaInicio, hQuartaFim, hQuintaInicio, hQuintaFim, hSextaInicio, hSextaFim, hSabadoInicio, hSabadoFim));
    
    return result



@app.post("/criarhorario")
def criaHorario(item: dict):
    
    retorno = alter("INSERT INTO horariofuncionamento (hDomingoInicio, hDomingoFim, hSegundaInicio, " +
        "hSegundaFim, hTercaInicio, hTercaFim, hQuartaInicio, hQuartaFim, " + 
        "hQuintaInicio, hQuintaFim, hSextaInicio, hSextaFim, hSabadoInicio,hSabadoFim)" + 
        "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", 
        (item["hdomingoinicio"], item["hdomingofim"], item["hsegundainicio"], item["hsegundafim"], 
         item["htercainicio"], item["htercafim"], item["hquartainicio"], item["hquartafim"],
         item["hquintainicio"], item["hquintafim"], item["hsextainicio"], item["hsextafim"],
         item["hsabadoinicio"], item["hsabadofim"]))

    if(retorno == 'Sucesso'):
        result = 1
    else:
        result = 0
    
    return result

@app.delete("/deletahorario&id={id}")
def deletaHorario(id):
    
    retorno = alter("DELETE FROM horariofuncionamento WHERE id = %s", (id,))

    if(retorno == 'Sucesso'):
        result = 1
    else:
        result = 0
    
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
                  " a.notaambiente, a.descriambiente, a.notapreco, a.descripreco, a.dataehora FROM avaliacao as a")

    result = []
    for (id, idCli, idEstab, media, notaRefeicao, descriRefeicao,
                 notaAtendimento, descriAtendimento,
                 notaAmbiente, descriAmbiente,
                 notaPreco, descriPreco,
                 dataeHora) in retorno:
        result.append(model.Avaliacao(id, idCli, idEstab, media, notaRefeicao, descriRefeicao,
                                      notaAtendimento, descriAtendimento, notaAmbiente, descriAmbiente,
                                      notaPreco, descriPreco, dataeHora))
    
    return result

@app.get("/avaliacao&id={id}")
def retornaAvaliacaoPorId(id):
    
    retorno = retByValue("SELECT a.id, a.idcli, a.idestab, a.media, a.notarefeicao, a.descrirefeicao, a.notaatendimento, a.descriatendimento, " +
                  " a.notaambiente, a.descriambiente, a.notapreco, a.descripreco, a.dataehora FROM avaliacao as a WHERE c.id = %s", (id,))

    result = []
    for (idn, idCli, idEstab, media, notaRefeicao, descriRefeicao,
                 notaAtendimento, descriAtendimento,
                 notaAmbiente, descriAmbiente,
                 notaPreco, descriPreco,
                 dataeHora) in retorno:
        result.append(model.Avaliacao(idn, idCli, idEstab, media, notaRefeicao, descriRefeicao,
                                      notaAtendimento, descriAtendimento, notaAmbiente, descriAmbiente,
                                      notaPreco, descriPreco, dataeHora))
    return result

#Preciso fazer a chamada da procedure
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
    
    '''retorno = alter("INSERT INTO avaliacao (idcli, idestab, media, notarefeicao, descrirefeicao, notaatendimento, descriatendimento, notaambiente, descriambiente, notapreco, descripreco, dataehora)"+ 
                    "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
                    (item["idcli"], item["idestab"], item["media"], item["notarefeicao"], des_refeicao, item["notaatendimento"], des_atendi, item["notaambiente"], des_amb, item["notapreco"], des_pre, dataCriacao))'''

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
    
    
    retorno = ret("SELECT c.id, c.descricao FROM categoria as c")

    result = []
    for (id, descricao) in retorno:
        result.append(model.Categoria(id, descricao))
    
    return result

@app.get("/avaliacao&id={id}")
def retornaAvaliacaoPorId(id):
    
    retorno = retByValue("SELECT c.id, c.descricao FROM categoria as c WHERE c.id = %s", (id,))

    result = []
    for (idn, descricao) in retorno:
        result.append(model.Categoria(idn, descricao))
    return result