CREATE TABLE cliente (
	id SERIAL primary key not null,
    email varchar(255) unique not null,  
    nome varchar(255) not null,
    senha varchar(255) not null,
	cpf char(11) not null unique,
    dataNascimento date not null,
    foto bytea,
    tipo varchar(50) not null,
	dataeHoraCriacao timestamp not null,
    CHECK (tipo = 'Morador' OR tipo = 'Estudante' OR tipo = 'Republica')
);

CREATE TABLE endereco (
  id serial primary key,
  rua varchar(255) not null,
  numero int not null, 
  complem varchar(255),
  bairro varchar(255) not null,
  cep char(8) not null
);

CREATE TABLE horarioFuncionamento (
    id SERIAL primary key not null,
	hDomingoInicio time not null,
    hDomingoFim time not null,
    hSegundaInicio time not null,
    hSegundaFim time not null,
    hTercaInicio time not null,
    hTercaFim time not null,
    hQuartaInicio time not null,
    hQuartaFim time not null,
    hQuintaInicio time not null,
    hQuintaFim time not null,
	hSextaInicio time not null,
    hSextaFim time not null,
	hSabadoInicio time not null,
    hSabadoFim time not null
);

CREATE TABLE categoria (
    id serial primary key,
	descricao varchar(255) not null    
);

CREATE TABLE estabelecimento (
    id SERIAL primary key not null,
    nome varchar(255) not null,
    cnpj char(14) not null,
    email varchar(255) not null,
    senha varchar(255) not null,
    contato varchar(50) not null,
    foto bytea,
	descricao text,
	idEndereco int not null,
    idHorarioFunc int not null,
    idCategoria int not null,
	FOREIGN KEY(idEndereco)
		REFERENCES endereco(id),
	FOREIGN KEY(idHorarioFunc) 
   		REFERENCES horarioFuncionamento(id),
	FOREIGN KEY(idCategoria) 
   		REFERENCES categoria(id)
);

CREATE TABLE avaliacao (
    --id int primary key,
	id serial primary key,
	idCli int not null,
	idEstab int not null,
	media decimal,
    notaRefeicao decimal not null,
	descriRefeicao text,
    notaAtendimento decimal not null,
	descriAtendimento text,
    notaAmbiente decimal not null,
	descriAmbiente text,
    notaPreco decimal not null,
	descriPreco text,
    dataeHora timestamp not null,
	FOREIGN KEY(idCli)
		REFERENCES cliente(id),
	FOREIGN KEY(idEstab) 
   		REFERENCES estabelecimento(id)
    
);

/*Lógica de inserção de estabelecimento*/

CREATE OR REPLACE PROCEDURE inserir_estabelecimento(nome varchar(255), cnpj char(14), email varchar(255),senha varchar(255), contato varchar(50), foto bytea, descricao_e text, rua varchar(255), numero int, complem varchar(255), bairro varchar(255), cep char(8), hDomingoInicio time, hDomingoFim time,bhSegundaInicio time, hSegundaFim time, hTercaInicio time, hTercaFim time, hQuartaInicio time, hQuartaFim time, hQuintaInicio time, hQuintaFim time, hSextaInicio time, hSextaFim time, hSabadoInicio time, hSabadoFim time, idcategoria int)
AS $$
DECLARE
	idendereco INT;
	idhorariofunc INT;
	--id_categoria INT;
BEGIN
   	-- Inserir endereço
	INSERT INTO endereco(rua, numero, complem, bairro, cep )VALUES(rua, numero, complem, bairro, cep)RETURNING id INTO idendereco;
	
	--Inserir Horário de funcionamento
	INSERT INTO horariofuncionamento (hDomingoInicio, hDomingoFim, hSegundaInicio, hSegundaFim, hTercaInicio, hTercaFim, hQuartaInicio, hQuartaFim, hQuintaInicio, hQuintaFim, hSextaInicio, hSextaFim, hSabadoInicio,hSabadoFim) VALUES(hDomingoInicio, hDomingoFim,bhSegundaInicio, hSegundaFim, hTercaInicio, hTercaFim, hQuartaInicio, hQuartaFim, hQuintaInicio, hQuintaFim, hSextaInicio, hSextaFim, hSabadoInicio, hSabadoFim)RETURNING id INTO idhorariofunc;
	
	--Inserir estabelecimento referenciando endereco e horario, considerando que o id da caegoria vem da seleção que o usuario faz
	INSERT INTO estabelecimento(nome, cnpj, email, senha, contato, foto, descricao, idEndereco,idHorarioFunc, idCategoria) VALUES(nome, cnpj, email, senha, contato, foto, descricao_e, idendereco, idhorariofunc, idcategoria);
END;
$$ LANGUAGE plpgsql;

--CALL inserir_avaliacao(6, 4, 4.5, 'Muito boa, mas podia ser maior',5, 'ótimo atendimento', 5, 'Ambiente agradável', '3', 'Um pouco caro', '2023/06/06 16:56:00');

CREATE OR REPLACE PROCEDURE inserir_avaliacao(idcli INT, idestab INT, n_refeicao decimal, descrirefeicao text, n_atendimento decimal, descriatendimento text, n_ambiente decimal, descriambiente text, n_preco decimal, descripreco text, dataehora timestamp)
AS $$
DECLARE
    media_a DECIMAL;
BEGIN
	-- Calcular Média
	media_a = (n_refeicao + n_atendimento + n_ambiente + n_preco)/4;
   	-- Inserir avaliacao
	INSERT INTO avaliacao(idcli, idestab, media, notarefeicao, descrirefeicao, notaatendimento, descriatendimento, notaambiente, descriambiente, notapreco, descripreco, dataehora)VALUES(idcli, idestab, media_a, n_refeicao, descrirefeicao, n_atendimento, descriatendimento, n_ambiente, descriambiente, n_preco, descripreco, dataehora);

END;
$$ LANGUAGE plpgsql;

/*Triggers*/

-- Quando um estabelecimento for deletado é necessário deletar seu endereço e horário de funcionamento
CREATE OR REPLACE FUNCTION excluir_estabelecimento_trigger()
    RETURNS TRIGGER AS $$
BEGIN
    -- Excluir horário de funcionamento
    DELETE FROM horariofuncionamento WHERE id = OLD.idHorarioFunc;
  
    -- Excluir endereço
    DELETE FROM endereco WHERE id = OLD.idendereco;
  
    -- Retornar o resultado do gatilho
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_excluir_estabelecimento
    AFTER DELETE ON estabelecimento
    FOR EACH ROW
    EXECUTE FUNCTION excluir_estabelecimento_trigger();

-- Excluí avaliações ligadas ao restaurante que será excluído
CREATE OR REPLACE FUNCTION excluir_estabelecimento_trigger()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM avaliacao WHERE idEstab = OLD.id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_excluir_avaliacoes
BEFORE DELETE ON estabelecimento
FOR EACH ROW
EXECUTE FUNCTION excluir_avaliacoes();


/*Cliente*/

-- Quando um cliente for excluído é necessário excluir suas avaliações
CREATE OR REPLACE FUNCTION excluir_cliente_trigger()
    RETURNS TRIGGER AS $$
BEGIN

    DELETE FROM avaliacao WHERE idcli = OLD.id;
  
    -- Retornar o resultado do gatilho
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_excluir_cliente
    BEFORE DELETE ON cliente
    FOR EACH ROW
    EXECUTE FUNCTION excluir_cliente_trigger();

/*Avaliação*/

CREATE OR REPLACE FUNCTION calcula_media()
    RETURNS TRIGGER AS $$
DECLARE
    media_a DECIMAL;	
BEGIN
    -- Calcular Média
	NEW.media := (NEW.notarefeicao + NEW.notaatendimento + NEW.notaambiente +NEW.notapreco) / 4.0;
	/*SELECT SUM(notarefeicao, notaatendimento, notaambiente, notapreco)/4 INTO media_a;
	UPDATE avaliacao SET media = media_a WHERE id = */
  
    -- Retornar o resultado do gatilho
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_atualiza_media
    BEFORE UPDATE OF notarefeicao, notaatendimento, notaambiente, notapreco ON avaliacao
    FOR EACH ROW
    EXECUTE FUNCTION calcula_media();

-- Consultar
/*SELECT * FROM estabelecimento
SELECT * FROM avaliacao
SELECT * FROM horariofuncionamento
SELECT * FROM cliente
SELECT e.nome, c.id, c.descricao FROM estabelecimento e JOIN categoria c ON e.idcategoria = c.id

SELECT (notarefeicao + notaatendimento + notaambiente + notapreco)/4 FROM avaliacao;

INSERT INTO categoria(descricao) VALUES('hamburgueria')
DELETE FROM estabelecimento
DELETE FROM categoria WHERE id = 7
DELETE FROM endereco
DELETE FROM horariofuncionamento*/