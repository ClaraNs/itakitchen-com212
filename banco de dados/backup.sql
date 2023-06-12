PGDMP     1    "                {         
   itakitchen %   12.15 (Ubuntu 12.15-0ubuntu0.20.04.1) %   12.15 (Ubuntu 12.15-0ubuntu0.20.04.1) @    l           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            m           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            n           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            o           1262    16506 
   itakitchen    DATABASE     |   CREATE DATABASE itakitchen WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'pt_BR.UTF-8' LC_CTYPE = 'pt_BR.UTF-8';
    DROP DATABASE itakitchen;
                postgres    false                        3079    16625    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            p           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2            �            1255    24817    excluir_avaliacoes()    FUNCTION     �   CREATE FUNCTION public.excluir_avaliacoes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM avaliacao WHERE idestab = OLD.id;
    RETURN OLD;
END;
$$;
 +   DROP FUNCTION public.excluir_avaliacoes();
       public          postgres    false                       1255    16839    excluir_cliente_trigger()    FUNCTION     �   CREATE FUNCTION public.excluir_cliente_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

    DELETE FROM avaliacao WHERE idcli = OLD.id;
  
    -- Retornar o resultado do gatilho
    RETURN OLD;
END;
$$;
 0   DROP FUNCTION public.excluir_cliente_trigger();
       public          postgres    false            �            1255    16847 +   excluir_estabelecimento_avaliacao_trigger()    FUNCTION       CREATE FUNCTION public.excluir_estabelecimento_avaliacao_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	-- Excluir avaliações
	DELETE FROM avaliacao WHERE idestab = OLD.id;
  
    -- Retornar o resultado do gatilho
    RETURN OLD;
END;
$$;
 B   DROP FUNCTION public.excluir_estabelecimento_avaliacao_trigger();
       public          postgres    false            
           1255    16726 !   excluir_estabelecimento_trigger()    FUNCTION     m  CREATE FUNCTION public.excluir_estabelecimento_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Excluir horário de funcionamento
    DELETE FROM horariofuncionamento WHERE id = OLD.idhorariofunc;
  
    -- Excluir endereço
    DELETE FROM endereco WHERE id = OLD.idendereco;
  
    -- Retornar o resultado do gatilho
    RETURN OLD;
END;
$$;
 8   DROP FUNCTION public.excluir_estabelecimento_trigger();
       public          postgres    false            	           1255    16845 |   inserir_avaliacao(integer, integer, numeric, text, numeric, text, numeric, text, numeric, text, timestamp without time zone) 	   PROCEDURE       CREATE PROCEDURE public.inserir_avaliacao(idcli integer, idestab integer, n_refeicao numeric, descrirefeicao text, n_atendimento numeric, descriatendimento text, n_ambiente numeric, descriambiente text, n_preco numeric, descripreco text, dataehora timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
DECLARE
    media_a DECIMAL;
BEGIN
	-- Calcular Média
	media_a = (n_refeicao + n_atendimento + n_ambiente + n_preco)/4;
   	-- Inserir avaliacao
	INSERT INTO avaliacao(idcli, idestab, media, notarefeicao, descrirefeicao, notaatendimento, descriatendimento, notaambiente, descriambiente, notapreco, descripreco, dataehora)VALUES(idcli, idestab, media_a, n_refeicao, descrirefeicao, n_atendimento, descriatendimento, n_ambiente, descriambiente, n_preco, descripreco, dataehora);

END;
$$;
   DROP PROCEDURE public.inserir_avaliacao(idcli integer, idestab integer, n_refeicao numeric, descrirefeicao text, n_atendimento numeric, descriatendimento text, n_ambiente numeric, descriambiente text, n_preco numeric, descripreco text, dataehora timestamp without time zone);
       public          postgres    false                       1255    16838 !  inserir_estabelecimento(character varying, character, character varying, character varying, character varying, bytea, text, character varying, integer, character varying, character varying, character, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, integer) 	   PROCEDURE     �  CREATE PROCEDURE public.inserir_estabelecimento(nome character varying, cnpj character, email character varying, senha character varying, contato character varying, foto bytea, descricao_e text, rua character varying, numero integer, complem character varying, bairro character varying, cep character, hdomingoinicio time without time zone, hdomingofim time without time zone, bhsegundainicio time without time zone, hsegundafim time without time zone, htercainicio time without time zone, htercafim time without time zone, hquartainicio time without time zone, hquartafim time without time zone, hquintainicio time without time zone, hquintafim time without time zone, hsextainicio time without time zone, hsextafim time without time zone, hsabadoinicio time without time zone, hsabadofim time without time zone, idcategoria integer)
    LANGUAGE plpgsql
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
$$;
 B  DROP PROCEDURE public.inserir_estabelecimento(nome character varying, cnpj character, email character varying, senha character varying, contato character varying, foto bytea, descricao_e text, rua character varying, numero integer, complem character varying, bairro character varying, cep character, hdomingoinicio time without time zone, hdomingofim time without time zone, bhsegundainicio time without time zone, hsegundafim time without time zone, htercainicio time without time zone, htercafim time without time zone, hquartainicio time without time zone, hquartafim time without time zone, hquintainicio time without time zone, hquintafim time without time zone, hsextainicio time without time zone, hsextafim time without time zone, hsabadoinicio time without time zone, hsabadofim time without time zone, idcategoria integer);
       public          postgres    false            �            1259    24865 	   avaliacao    TABLE     �  CREATE TABLE public.avaliacao (
    id integer NOT NULL,
    idcli integer NOT NULL,
    idestab integer NOT NULL,
    media numeric,
    notarefeicao numeric NOT NULL,
    descrirefeicao text,
    notaatendimento numeric NOT NULL,
    descriatendimento text,
    notaambiente numeric NOT NULL,
    descriambiente text,
    notapreco numeric NOT NULL,
    descripreco text,
    dataehora timestamp without time zone NOT NULL
);
    DROP TABLE public.avaliacao;
       public         heap    postgres    false            �            1259    24863    avaliacao_id_seq    SEQUENCE     �   CREATE SEQUENCE public.avaliacao_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.avaliacao_id_seq;
       public          postgres    false    214            q           0    0    avaliacao_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.avaliacao_id_seq OWNED BY public.avaliacao.id;
          public          postgres    false    213            �            1259    16669 	   categoria    TABLE     j   CREATE TABLE public.categoria (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL
);
    DROP TABLE public.categoria;
       public         heap    postgres    false            �            1259    16667    categoria_id_seq    SEQUENCE     �   CREATE SEQUENCE public.categoria_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.categoria_id_seq;
       public          postgres    false    208            r           0    0    categoria_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.categoria_id_seq OWNED BY public.categoria.id;
          public          postgres    false    207            �            1259    16509    cliente    TABLE     	  CREATE TABLE public.cliente (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    nome character varying(255) NOT NULL,
    senha character varying(255) NOT NULL,
    cpf character(11) NOT NULL,
    datanascimento date NOT NULL,
    foto bytea,
    tipo character varying(50) NOT NULL,
    dataehoracriacao timestamp without time zone NOT NULL,
    CONSTRAINT cliente_tipo_check CHECK ((((tipo)::text = 'Morador'::text) OR ((tipo)::text = 'Estudante'::text) OR ((tipo)::text = 'Republica'::text)))
);
    DROP TABLE public.cliente;
       public         heap    postgres    false            �            1259    16507    cliente_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cliente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.cliente_id_seq;
       public          postgres    false    204            s           0    0    cliente_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.cliente_id_seq OWNED BY public.cliente.id;
          public          postgres    false    203            �            1259    24828    endereco    TABLE     �   CREATE TABLE public.endereco (
    id integer NOT NULL,
    rua character varying(255) NOT NULL,
    numero integer NOT NULL,
    complem character varying(255),
    bairro character varying(255) NOT NULL,
    cep character(8) NOT NULL
);
    DROP TABLE public.endereco;
       public         heap    postgres    false            �            1259    24826    endereco_id_seq    SEQUENCE     �   CREATE SEQUENCE public.endereco_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.endereco_id_seq;
       public          postgres    false    210            t           0    0    endereco_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.endereco_id_seq OWNED BY public.endereco.id;
          public          postgres    false    209            �            1259    24839    estabelecimento    TABLE     �  CREATE TABLE public.estabelecimento (
    id integer NOT NULL,
    nome character varying(255) NOT NULL,
    cnpj character(14) NOT NULL,
    email character varying(255) NOT NULL,
    senha character varying(255) NOT NULL,
    contato character varying(50) NOT NULL,
    foto bytea,
    descricao text,
    idendereco integer NOT NULL,
    idhorariofunc integer NOT NULL,
    idcategoria integer NOT NULL
);
 #   DROP TABLE public.estabelecimento;
       public         heap    postgres    false            �            1259    24837    estabelecimento_id_seq    SEQUENCE     �   CREATE SEQUENCE public.estabelecimento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.estabelecimento_id_seq;
       public          postgres    false    212            u           0    0    estabelecimento_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.estabelecimento_id_seq OWNED BY public.estabelecimento.id;
          public          postgres    false    211            �            1259    16533    horariofuncionamento    TABLE     �  CREATE TABLE public.horariofuncionamento (
    id integer NOT NULL,
    hdomingoinicio time without time zone NOT NULL,
    hdomingofim time without time zone NOT NULL,
    hsegundainicio time without time zone NOT NULL,
    hsegundafim time without time zone NOT NULL,
    htercainicio time without time zone NOT NULL,
    htercafim time without time zone NOT NULL,
    hquartainicio time without time zone NOT NULL,
    hquartafim time without time zone NOT NULL,
    hquintainicio time without time zone NOT NULL,
    hquintafim time without time zone NOT NULL,
    hsextainicio time without time zone NOT NULL,
    hsextafim time without time zone NOT NULL,
    hsabadoinicio time without time zone NOT NULL,
    hsabadofim time without time zone NOT NULL
);
 (   DROP TABLE public.horariofuncionamento;
       public         heap    postgres    false            �            1259    16531    horariofuncionamento_id_seq    SEQUENCE     �   CREATE SEQUENCE public.horariofuncionamento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.horariofuncionamento_id_seq;
       public          postgres    false    206            v           0    0    horariofuncionamento_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.horariofuncionamento_id_seq OWNED BY public.horariofuncionamento.id;
          public          postgres    false    205            �           2604    24868    avaliacao id    DEFAULT     l   ALTER TABLE ONLY public.avaliacao ALTER COLUMN id SET DEFAULT nextval('public.avaliacao_id_seq'::regclass);
 ;   ALTER TABLE public.avaliacao ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    214    214            �           2604    16672    categoria id    DEFAULT     l   ALTER TABLE ONLY public.categoria ALTER COLUMN id SET DEFAULT nextval('public.categoria_id_seq'::regclass);
 ;   ALTER TABLE public.categoria ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    208    207    208            �           2604    16512 
   cliente id    DEFAULT     h   ALTER TABLE ONLY public.cliente ALTER COLUMN id SET DEFAULT nextval('public.cliente_id_seq'::regclass);
 9   ALTER TABLE public.cliente ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    204    204            �           2604    24831    endereco id    DEFAULT     j   ALTER TABLE ONLY public.endereco ALTER COLUMN id SET DEFAULT nextval('public.endereco_id_seq'::regclass);
 :   ALTER TABLE public.endereco ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    210    209    210            �           2604    24842    estabelecimento id    DEFAULT     x   ALTER TABLE ONLY public.estabelecimento ALTER COLUMN id SET DEFAULT nextval('public.estabelecimento_id_seq'::regclass);
 A   ALTER TABLE public.estabelecimento ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    212    212            �           2604    16536    horariofuncionamento id    DEFAULT     �   ALTER TABLE ONLY public.horariofuncionamento ALTER COLUMN id SET DEFAULT nextval('public.horariofuncionamento_id_seq'::regclass);
 F   ALTER TABLE public.horariofuncionamento ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    206    205    206            i          0    24865 	   avaliacao 
   TABLE DATA           �   COPY public.avaliacao (id, idcli, idestab, media, notarefeicao, descrirefeicao, notaatendimento, descriatendimento, notaambiente, descriambiente, notapreco, descripreco, dataehora) FROM stdin;
    public          postgres    false    214   �c       c          0    16669 	   categoria 
   TABLE DATA           2   COPY public.categoria (id, descricao) FROM stdin;
    public          postgres    false    208   �c       _          0    16509    cliente 
   TABLE DATA           l   COPY public.cliente (id, email, nome, senha, cpf, datanascimento, foto, tipo, dataehoracriacao) FROM stdin;
    public          postgres    false    204   d       e          0    24828    endereco 
   TABLE DATA           I   COPY public.endereco (id, rua, numero, complem, bairro, cep) FROM stdin;
    public          postgres    false    210   0d       g          0    24839    estabelecimento 
   TABLE DATA           �   COPY public.estabelecimento (id, nome, cnpj, email, senha, contato, foto, descricao, idendereco, idhorariofunc, idcategoria) FROM stdin;
    public          postgres    false    212   Md       a          0    16533    horariofuncionamento 
   TABLE DATA           �   COPY public.horariofuncionamento (id, hdomingoinicio, hdomingofim, hsegundainicio, hsegundafim, htercainicio, htercafim, hquartainicio, hquartafim, hquintainicio, hquintafim, hsextainicio, hsextafim, hsabadoinicio, hsabadofim) FROM stdin;
    public          postgres    false    206   jd       w           0    0    avaliacao_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.avaliacao_id_seq', 6, true);
          public          postgres    false    213            x           0    0    categoria_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.categoria_id_seq', 10, true);
          public          postgres    false    207            y           0    0    cliente_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.cliente_id_seq', 7, true);
          public          postgres    false    203            z           0    0    endereco_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.endereco_id_seq', 6, true);
          public          postgres    false    209            {           0    0    estabelecimento_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.estabelecimento_id_seq', 6, true);
          public          postgres    false    211            |           0    0    horariofuncionamento_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.horariofuncionamento_id_seq', 51, true);
          public          postgres    false    205            �           2606    24873    avaliacao avaliacao_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.avaliacao
    ADD CONSTRAINT avaliacao_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.avaliacao DROP CONSTRAINT avaliacao_pkey;
       public            postgres    false    214            �           2606    16674    categoria categoria_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.categoria DROP CONSTRAINT categoria_pkey;
       public            postgres    false    208            �           2606    16522    cliente cliente_cpf_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_cpf_key UNIQUE (cpf);
 A   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_cpf_key;
       public            postgres    false    204            �           2606    16520    cliente cliente_email_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_email_key UNIQUE (email);
 C   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_email_key;
       public            postgres    false    204            �           2606    16518    cliente cliente_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
       public            postgres    false    204            �           2606    24836    endereco endereco_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.endereco DROP CONSTRAINT endereco_pkey;
       public            postgres    false    210            �           2606    24847 $   estabelecimento estabelecimento_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.estabelecimento
    ADD CONSTRAINT estabelecimento_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.estabelecimento DROP CONSTRAINT estabelecimento_pkey;
       public            postgres    false    212            �           2606    16538 .   horariofuncionamento horariofuncionamento_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.horariofuncionamento
    ADD CONSTRAINT horariofuncionamento_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.horariofuncionamento DROP CONSTRAINT horariofuncionamento_pkey;
       public            postgres    false    206            �           2620    24823    cliente tr_excluir_cliente    TRIGGER     �   CREATE TRIGGER tr_excluir_cliente BEFORE DELETE ON public.cliente FOR EACH ROW EXECUTE FUNCTION public.excluir_cliente_trigger();
 3   DROP TRIGGER tr_excluir_cliente ON public.cliente;
       public          postgres    false    204    267            �           2620    24886 *   estabelecimento tr_excluir_estabelecimento    TRIGGER     �   CREATE TRIGGER tr_excluir_estabelecimento AFTER DELETE ON public.estabelecimento FOR EACH ROW EXECUTE FUNCTION public.excluir_estabelecimento_trigger();
 C   DROP TRIGGER tr_excluir_estabelecimento ON public.estabelecimento;
       public          postgres    false    212    266            �           2620    24885 *   estabelecimento trigger_excluir_avaliacoes    TRIGGER     �   CREATE TRIGGER trigger_excluir_avaliacoes BEFORE DELETE ON public.estabelecimento FOR EACH ROW EXECUTE FUNCTION public.excluir_avaliacoes();
 C   DROP TRIGGER trigger_excluir_avaliacoes ON public.estabelecimento;
       public          postgres    false    212    252            �           2606    24874    avaliacao avaliacao_idcli_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.avaliacao
    ADD CONSTRAINT avaliacao_idcli_fkey FOREIGN KEY (idcli) REFERENCES public.cliente(id);
 H   ALTER TABLE ONLY public.avaliacao DROP CONSTRAINT avaliacao_idcli_fkey;
       public          postgres    false    3533    214    204            �           2606    24879     avaliacao avaliacao_idestab_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.avaliacao
    ADD CONSTRAINT avaliacao_idestab_fkey FOREIGN KEY (idestab) REFERENCES public.estabelecimento(id);
 J   ALTER TABLE ONLY public.avaliacao DROP CONSTRAINT avaliacao_idestab_fkey;
       public          postgres    false    212    214    3541            �           2606    24858 0   estabelecimento estabelecimento_idcategoria_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.estabelecimento
    ADD CONSTRAINT estabelecimento_idcategoria_fkey FOREIGN KEY (idcategoria) REFERENCES public.categoria(id);
 Z   ALTER TABLE ONLY public.estabelecimento DROP CONSTRAINT estabelecimento_idcategoria_fkey;
       public          postgres    false    208    3537    212            �           2606    24848 /   estabelecimento estabelecimento_idendereco_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.estabelecimento
    ADD CONSTRAINT estabelecimento_idendereco_fkey FOREIGN KEY (idendereco) REFERENCES public.endereco(id);
 Y   ALTER TABLE ONLY public.estabelecimento DROP CONSTRAINT estabelecimento_idendereco_fkey;
       public          postgres    false    212    3539    210            �           2606    24853 2   estabelecimento estabelecimento_idhorariofunc_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.estabelecimento
    ADD CONSTRAINT estabelecimento_idhorariofunc_fkey FOREIGN KEY (idhorariofunc) REFERENCES public.horariofuncionamento(id);
 \   ALTER TABLE ONLY public.estabelecimento DROP CONSTRAINT estabelecimento_idhorariofunc_fkey;
       public          postgres    false    206    3535    212            i      x������ � �      c   .   x����J,��K-N��,�ρ083s�J��KS�2�b���� 5Cb      _      x������ � �      e      x������ � �      g      x������ � �      a      x������ � �     