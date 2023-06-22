class Cliente:
    def __init__(self, id, email, nome, cpf, dataNascimento, foto, tipo):
        self.id = id
        self.email = email
        self.nome = nome
        self.cpf = cpf
        self.dataNascimento = dataNascimento
        self.foto = foto
        self.tipo = tipo
        
class Endereco:
    def __init__(self, id, rua, numero, complem, bairro, cep):
        self.id = id
        self.rua = rua
        self.numero = numero
        self.complem = complem
        self.bairro = bairro
        self.cep = cep
        
class HorarioFuncionamento:
    def __init__(self, id, hDomingoInicio, hDomingoFim, hSegundaInicio,
    hSegundaFim, hTercaInicio, hTercaFim, hQuartaInicio, hQuartaFim,
    hQuintaInicio, hQuintaFim, hSextaInicio, hSextaFim, hSabadoInicio,hSabadoFim ):
        self.id = id
        self.hDomingoInicio = hDomingoInicio
        self.hDomingoFim = hDomingoFim
        self.hSegundaInicio = hSegundaInicio
        self.hSegundaFim = hSegundaFim
        self.hTercaInicio = hTercaInicio
        self.hTercaFim = hTercaFim
        self.hQuartaInicio = hQuartaInicio
        self.hQuartaFim = hQuartaFim
        self.hQuintaInicio = hQuintaInicio
        self.hQuintaFim = hQuintaFim
        self.hSextaInicio = hSextaInicio
        self.hSextaFim = hSextaFim
        self.hSabadoInicio = hSabadoInicio
        self.hSabadoFim = hSabadoFim
        
class Categoria:
    def __init__(self, id, descricao):
        self.id = id
        self.descricao = descricao
    
class Estabelecimento:
    def __init__(self, id, nome, cnpj, email, contato, foto, descricao, idEndereco, idHorario, idCategoria):
        self.id = id
        self.nome = nome
        self.cnpj = cnpj
        self.email = email
        self.contato = contato
        self.foto = foto
        self.descricao = descricao
        self.idEndereco = idEndereco
        self.idHorario = idHorario
        self.idCategoria = idCategoria
        
class Avaliacao:
    def __init__(self, id, idCli, idEstab, media, notaRefeicao, descriRefeicao,
                 notaAtendimento, descriAtendimento,
                 notaAmbiente, descriAmbiente,
                 notaPreco, descriPreco,
                 dataeHora):
        self.id = id
        self.idCli = idCli
        self.idEstab = idEstab
        self.media = media
        self.notaRefeicao = notaRefeicao
        self.descriRefeicao = descriRefeicao
        self.notaAtendimento = notaAtendimento
        self.descriAtendimento = descriAtendimento
        self.notaAmbiente = notaAmbiente
        self.descriAmbiente = descriAmbiente
        self.notaPreco = notaPreco
        self.descriPreco = descriPreco
        self.dataeHora = dataeHora