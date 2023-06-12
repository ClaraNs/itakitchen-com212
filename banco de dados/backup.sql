PGDMP                         {         
   itakitchen %   12.15 (Ubuntu 12.15-0ubuntu0.20.04.1) %   12.15 (Ubuntu 12.15-0ubuntu0.20.04.1) B    n           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            o           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            p           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            q           1262    16506 
   itakitchen    DATABASE     |   CREATE DATABASE itakitchen WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'pt_BR.UTF-8' LC_CTYPE = 'pt_BR.UTF-8';
    DROP DATABASE itakitchen;
                postgres    false                        3079    16625    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            r           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2                       1255    25191    calcula_media()    FUNCTION     �  CREATE FUNCTION public.calcula_media() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 &   DROP FUNCTION public.calcula_media();
       public          postgres    false            �            1255    24817    excluir_avaliacoes()    FUNCTION     �   CREATE FUNCTION public.excluir_avaliacoes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM avaliacao WHERE idestab = OLD.id;
    RETURN OLD;
END;
$$;
 +   DROP FUNCTION public.excluir_avaliacoes();
       public          postgres    false                       1255    16839    excluir_cliente_trigger()    FUNCTION     �   CREATE FUNCTION public.excluir_cliente_trigger() RETURNS trigger
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
    DELETE FROM horariofuncionamento WHERE id = OLD.idHorarioFunc;
  
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
       public          postgres    false                       1255    16838 !  inserir_estabelecimento(character varying, character, character varying, character varying, character varying, bytea, text, character varying, integer, character varying, character varying, character, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, time without time zone, integer) 	   PROCEDURE     �  CREATE PROCEDURE public.inserir_estabelecimento(nome character varying, cnpj character, email character varying, senha character varying, contato character varying, foto bytea, descricao_e text, rua character varying, numero integer, complem character varying, bairro character varying, cep character, hdomingoinicio time without time zone, hdomingofim time without time zone, bhsegundainicio time without time zone, hsegundafim time without time zone, htercainicio time without time zone, htercafim time without time zone, hquartainicio time without time zone, hquartafim time without time zone, hquintainicio time without time zone, hquintafim time without time zone, hsextainicio time without time zone, hsextafim time without time zone, hsabadoinicio time without time zone, hsabadofim time without time zone, idcategoria integer)
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
       public          postgres    false    214            s           0    0    avaliacao_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.avaliacao_id_seq OWNED BY public.avaliacao.id;
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
       public          postgres    false    208            t           0    0    categoria_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.categoria_id_seq OWNED BY public.categoria.id;
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
       public          postgres    false    204            u           0    0    cliente_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.cliente_id_seq OWNED BY public.cliente.id;
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
       public          postgres    false    210            v           0    0    endereco_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.endereco_id_seq OWNED BY public.endereco.id;
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
       public          postgres    false    212            w           0    0    estabelecimento_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.estabelecimento_id_seq OWNED BY public.estabelecimento.id;
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
       public          postgres    false    206            x           0    0    horariofuncionamento_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.horariofuncionamento_id_seq OWNED BY public.horariofuncionamento.id;
          public          postgres    false    205            �           2604    25036    avaliacao id    DEFAULT     l   ALTER TABLE ONLY public.avaliacao ALTER COLUMN id SET DEFAULT nextval('public.avaliacao_id_seq'::regclass);
 ;   ALTER TABLE public.avaliacao ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    214    213    214            �           2604    25037    categoria id    DEFAULT     l   ALTER TABLE ONLY public.categoria ALTER COLUMN id SET DEFAULT nextval('public.categoria_id_seq'::regclass);
 ;   ALTER TABLE public.categoria ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    207    208    208            �           2604    25038 
   cliente id    DEFAULT     h   ALTER TABLE ONLY public.cliente ALTER COLUMN id SET DEFAULT nextval('public.cliente_id_seq'::regclass);
 9   ALTER TABLE public.cliente ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    204    204            �           2604    25039    endereco id    DEFAULT     j   ALTER TABLE ONLY public.endereco ALTER COLUMN id SET DEFAULT nextval('public.endereco_id_seq'::regclass);
 :   ALTER TABLE public.endereco ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    210    210            �           2604    25040    estabelecimento id    DEFAULT     x   ALTER TABLE ONLY public.estabelecimento ALTER COLUMN id SET DEFAULT nextval('public.estabelecimento_id_seq'::regclass);
 A   ALTER TABLE public.estabelecimento ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    212    211    212            �           2604    25041    horariofuncionamento id    DEFAULT     �   ALTER TABLE ONLY public.horariofuncionamento ALTER COLUMN id SET DEFAULT nextval('public.horariofuncionamento_id_seq'::regclass);
 F   ALTER TABLE public.horariofuncionamento ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    206    205    206            k          0    24865 	   avaliacao 
   TABLE DATA           �   COPY public.avaliacao (id, idcli, idestab, media, notarefeicao, descrirefeicao, notaatendimento, descriatendimento, notaambiente, descriambiente, notapreco, descripreco, dataehora) FROM stdin;
    public          postgres    false    214   �g       e          0    16669 	   categoria 
   TABLE DATA           2   COPY public.categoria (id, descricao) FROM stdin;
    public          postgres    false    208   �g       a          0    16509    cliente 
   TABLE DATA           l   COPY public.cliente (id, email, nome, senha, cpf, datanascimento, foto, tipo, dataehoracriacao) FROM stdin;
    public          postgres    false    204   3h       g          0    24828    endereco 
   TABLE DATA           I   COPY public.endereco (id, rua, numero, complem, bairro, cep) FROM stdin;
    public          postgres    false    210   ;�       i          0    24839    estabelecimento 
   TABLE DATA           �   COPY public.estabelecimento (id, nome, cnpj, email, senha, contato, foto, descricao, idendereco, idhorariofunc, idcategoria) FROM stdin;
    public          postgres    false    212   Ư       c          0    16533    horariofuncionamento 
   TABLE DATA           �   COPY public.horariofuncionamento (id, hdomingoinicio, hdomingofim, hsegundainicio, hsegundafim, htercainicio, htercafim, hquartainicio, hquartafim, hquintainicio, hquintafim, hsextainicio, hsextafim, hsabadoinicio, hsabadofim) FROM stdin;
    public          postgres    false    206   F�       y           0    0    avaliacao_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.avaliacao_id_seq', 9, true);
          public          postgres    false    213            z           0    0    categoria_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.categoria_id_seq', 10, true);
          public          postgres    false    207            {           0    0    cliente_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.cliente_id_seq', 7, true);
          public          postgres    false    203            |           0    0    endereco_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.endereco_id_seq', 16, true);
          public          postgres    false    209            }           0    0    estabelecimento_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.estabelecimento_id_seq', 16, true);
          public          postgres    false    211            ~           0    0    horariofuncionamento_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.horariofuncionamento_id_seq', 61, true);
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
       public            postgres    false    206            �           2620    25195    avaliacao tr_atualiza_media    TRIGGER     �   CREATE TRIGGER tr_atualiza_media BEFORE UPDATE OF notarefeicao, notaatendimento, notaambiente, notapreco ON public.avaliacao FOR EACH ROW EXECUTE FUNCTION public.calcula_media();
 4   DROP TRIGGER tr_atualiza_media ON public.avaliacao;
       public          postgres    false    214    267    214    214    214    214            �           2620    24823    cliente tr_excluir_cliente    TRIGGER     �   CREATE TRIGGER tr_excluir_cliente BEFORE DELETE ON public.cliente FOR EACH ROW EXECUTE FUNCTION public.excluir_cliente_trigger();
 3   DROP TRIGGER tr_excluir_cliente ON public.cliente;
       public          postgres    false    204    268            �           2620    24886 *   estabelecimento tr_excluir_estabelecimento    TRIGGER     �   CREATE TRIGGER tr_excluir_estabelecimento AFTER DELETE ON public.estabelecimento FOR EACH ROW EXECUTE FUNCTION public.excluir_estabelecimento_trigger();
 C   DROP TRIGGER tr_excluir_estabelecimento ON public.estabelecimento;
       public          postgres    false    266    212            �           2620    24885 *   estabelecimento trigger_excluir_avaliacoes    TRIGGER     �   CREATE TRIGGER trigger_excluir_avaliacoes BEFORE DELETE ON public.estabelecimento FOR EACH ROW EXECUTE FUNCTION public.excluir_avaliacoes();
 C   DROP TRIGGER trigger_excluir_avaliacoes ON public.estabelecimento;
       public          postgres    false    212    252            �           2606    24874    avaliacao avaliacao_idcli_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.avaliacao
    ADD CONSTRAINT avaliacao_idcli_fkey FOREIGN KEY (idcli) REFERENCES public.cliente(id);
 H   ALTER TABLE ONLY public.avaliacao DROP CONSTRAINT avaliacao_idcli_fkey;
       public          postgres    false    204    3534    214            �           2606    24879     avaliacao avaliacao_idestab_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.avaliacao
    ADD CONSTRAINT avaliacao_idestab_fkey FOREIGN KEY (idestab) REFERENCES public.estabelecimento(id);
 J   ALTER TABLE ONLY public.avaliacao DROP CONSTRAINT avaliacao_idestab_fkey;
       public          postgres    false    212    3542    214            �           2606    24858 0   estabelecimento estabelecimento_idcategoria_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.estabelecimento
    ADD CONSTRAINT estabelecimento_idcategoria_fkey FOREIGN KEY (idcategoria) REFERENCES public.categoria(id);
 Z   ALTER TABLE ONLY public.estabelecimento DROP CONSTRAINT estabelecimento_idcategoria_fkey;
       public          postgres    false    208    3538    212            �           2606    24848 /   estabelecimento estabelecimento_idendereco_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.estabelecimento
    ADD CONSTRAINT estabelecimento_idendereco_fkey FOREIGN KEY (idendereco) REFERENCES public.endereco(id);
 Y   ALTER TABLE ONLY public.estabelecimento DROP CONSTRAINT estabelecimento_idendereco_fkey;
       public          postgres    false    210    3540    212            �           2606    24853 2   estabelecimento estabelecimento_idhorariofunc_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.estabelecimento
    ADD CONSTRAINT estabelecimento_idhorariofunc_fkey FOREIGN KEY (idhorariofunc) REFERENCES public.horariofuncionamento(id);
 \   ALTER TABLE ONLY public.estabelecimento DROP CONSTRAINT estabelecimento_idhorariofunc_fkey;
       public          postgres    false    3536    206    212            k      x������ � �      e   .   x����J,��K-N��,�ρ083s�J��KS�2�b���� 5Cb      a      x���]�u�q���E.|k�g��\AP� �!��?���#����<�u$�@ζ�y߽�^k��QcTW�l?�?����o�����?��������W����������8~�����y(?������������_�����?��/��_�ſ������w�����w�?���W���?��?��o����?��/���?��OOLo.������~���o~���sx�[��a��췿�}s������!��~�y������/�M�������	�~����Bl��}�3��~�����7���Oo���������>�O����[���<�����s���s?����}l>�wh'������{��5����u�y�򋟆�����
O�\�_�����^d���S�đ�������sNkO�?}�����OK�M�5�m�\��۞'���|g�J���ů��z�_i����u�;��Wy��s�;U.�=�m�t�?;�Zf/�	�s�{�^�>=��|�q�n;��]�ݵ>�J�k�S,~��jK��Y������NY�Y�r%����5˪���K��{��4_ֵ���sku��N���2��;+������6�8O�ץu��f����>}?1ǴG����/�0�)#��'�vv|#��0��3˙�3����rmg-��O;W�=\Y�w�|��T�7>F�Z�O`��r�<�>��,u��͛S�Ǟk�5�re�������Ϙl�f�2&��5�z�~W=e����v�8�S�d3�O}o�O:m�<{�+��m=ϩlo�b�5���쩞=X�u�d���1\�m����4�<�þ\�ml��'�wřs�ߣ�x�\�9׻1��^�npW;��=<3���5nd��<#�0ڜ���0HmW���Z�J�s��ƥ��uF�R2�?�8/��űSm�i~�X�76s����&-��3�vzl�CA<{�'�l�:8�cgv�#��f���:��ysv�]O�1ΐc�on�56�;��[���Y\d�g�Yد�#�{w?|��r` \}���g�1g~'�1Gz�~'��O��s��Rr,a�3V>���_c%�sS�@f�}�������t�=�0���nOc[ҿ�O �'�q�gކ������|^�={;[	�f��hy3�� ����Ԟ��}n{7@�;��n2�0���R{ǣ����_��`x|���R;�7����F�7=����#Rˬm���6���E�������9��X�hlRO���,L, � ���Oz��d��w���}�_a&��	�ok����y�����B�xq��N?� �' o�ySn�ζ"�#QhL)���k�:�a�Y���Q�\:�����{��W`1rK^�w�����b�	Tl��~������&l��di����>�<Kxq��qa7������uB,��������!�=,}e�Ɖ�H#���h�.�80!�0v��9�C�g�[�%c7�Ů���Ϯt`�������E�S�	{�0:��u(<�\�h#��Q�3@v���(b)���B$l�J5�Z)���Y�X-!�"�����[�xi/D�����?q���!�qE�@�Wݸ ��q.�񜧺�#n���7��3w�jb!��yo�ނ�=)���o�Cjc��#]/����
X�G�ƆI����<�VPK;X����Q���2�,�5y0��ۀ1���FDW�-�:|�'(ᓀ�����>�������K��D�g�nj��p���/�Z�2��s�4,=��?W&��H\% �,$f+����J�,�s�l�b�X3(+��'\������{��cة�m&L�����F�5�6�����C��`ӣ?5�������c�!\�u�v^&Ȟ���(q#��m�r�p�r�N�f�S�+BV���z�NG�`S�%���ٽ���������,ΐ�a�W�6p�G�߉.�_ʷ���[6�]
�E+a��`x�ƾa�	�}��v��ya���Q�Q1�c�����B89�3/����F�X��Eln�r�qB&�0��l���L�1�<��5��a>,�H-��>A��xҪX�	C/�/1G9Fr� ��5�ܽ&P���g *#S3"��CN3< a�;Ʒ�+����z�aa�=n,���Nx�RuFmp`��/�q��=a�� ,B�ڸ����#�3��iL7ς��v�����B�0#q����g�� �y�&�p]�%t�w�������t���m�+1<n��
�""�D�7,yB��-rJ�U��}��	$,m|�C��C��^!o/H2��ٳ��^�~2qX��ى�x=6��\�x^<�`M5��ܿ������F�k�ύ=װ�Ԉi���x�B��S 0v�L��\<�Ľ�,~��S}kޘV�=��3�&V6e�Y#b��B�q����)-�1c�jd`�،&E0"�����`�ڜC0a�.V�C���a�!+sp��K"�#j�/尗X1K�`�j�! �&E����9�`����&�e"R ��ԃ�����M6�d48M��2�8?����F�"Z�2a7��U���%��ᰒ,7� �z4�	;�� �-�
������������Q0�Z�Up��ɷq�\9B���n����
�ӆn��ڬ0�\[и.7H/��[���hdz��D�>�H�H�bX; �ƢI��$���ۼu��x"t���JA��Lc65���9RQ��e�#���T ^�9Tt���a�� �U�G�Fy����d�='���I,טP��'t)B�|��`~��P�����l��|X*"�g+�"V�d�	\xr( �*��@$"kF(�~��k�r�A$H�͂�B/�&d��w?�`��Q�x`�( vJ�j� :k	W2����pۦT_�cP�(��/���K���ۇw�\	�Ӑ�	.�!+V\0o���x�4�׈w���S�
��� C8���?=��r�v���q��C��`�,�	(�_��{��e�Yb	y��>�ւ�b����D"Vc�(Mɘ���e|�E����G�	��wC���b�A4n�Fqa�%�_~���5��CF��
}�E�řn4se+�ČI*�K�`�vę^�o�����G��VD�2��c^�C��]l|���p_���t��e��ΰ\"  �b²��	%D2��[���:�6`���(�k�7�7;�W��"�ߡ�1#F���9蟼���l��cɱ��dٚ�	nm=�U�DrX�F8o �Cagډ.�f���L�!|npn�E�%7V5��Mv����SB�c?�A�}��6V���8˱q#`� a2�p+B��-7�
X ���;�I���!�,� �4p܃̫}���sEIkvD�>pQA���"v&��O�fd>q*-E�&ԩݓ�Z����z&�cIո���1�}oy1��4�����jVP�'�g���A��zޠkA7���e�H�=�&"O$�∄�Θ��8�E:Cn>Y�Vf{�<�9�)Hva3��f>#��V�{�\V��ɏA�gss+����	/�	�a�/���ɑ�d/T�8���P�˅��2�H,!�f�3��H�� 9<i�DC�p��"ᔝyL��ca��D2j�=����g�@�\u�|
lm��ڻp��	s�^� ����pK������n���#�xy'p>��v��qvA����L�o��`ob�{@ꉨ�k�� �x�F~���1����Xb
����I47��4�l���A�>2V�G��d��w��������#��(dL�Ҕ�{L%n43�a��r�������,M=�A�߭�	�cW�����	?�p

��"D�1���܋i��B�KF?��p�U�)(ش?B������0 X7��GD���{������W��B� w> ����s�Ju��u�K֐�˴�+@ ��gp�!F�0:^9,(�9��T+&	9�3��pg9"�b^��̳;�U���    IșksF8�a�P�w��u�L��,g{dA��6(z���0z��l�f�5 a�9��Y`_ Ϙ��p�ݰP&�0l��F�D�&����#�Ǘ$��%a|��w��CO&�n󟀓�R&�qG �L������nD���|nf���a�4?����8�p�Þ����'T�I����Ճ(�d��
��.�LEh�p��	��(�m5�L3W�S>�:$�Ny��^�%*?5tc�p]�h{W�����]x%�U:�b�6�9�L���	��0B7"+WH�lx2 "��!\("�e���	���/�;��Y�� ����Бl�����Z��d�(f&z��fMs���{ �˹��fm�u�BG��ZzM�B|M�a�hL�,���=���[��8ű	Ƽ�#H� G�}�����(P@�y���x�6��F�����v5D�����Y�����D�����D��SO����kG����Q��Zu����s���yr�' +|���M8
���a�H^�× h����.M�NL��-?������&Ĕ��h�w�@0L�������@�e��²����OMy�L�8n�/��1E���N�}!d1���.l2���V�=��n���A�(������&X-�jAΔKlPG�W�\L�|���[l�@z:�$磰��es�֧Ü�!��z�<�:l��Yp,��=�|{�ϲ�����3O��p�kx�^\a��!p�A8?�}�k�v8�)���/mb�T��+\�K�����K�'�v6��"z.�8p�1�{���Z��q�������{�`����i �z��gC��4L�"җy\�XI{"���0~i��*0@a&�f�v,�QZ�K0Dm���2���	*=X�5m�Qm���:L~=�Bkq�@�\P:,=�D2U��"�s����Z֐e��|���0թ�,_�����T�3�LLPq�
���L*�c�	F<�R-�O��%�m��2��D�û^pz�2<D]�R�����P�]���=`A�e��wa��s�-)>zxUt����,ow_�ac�\�Fm�e�8����L��9/����6�들Pr�v�	�8:���ۙ�pnDC���<��;Ý��c��"H=��-eL	�Z���L�,]���Ł��� �P��G��RP )���,D1O�lmx>�2�o�̬��<��<�?<,-�LQ��͗�}i/!�6$�������'m+H6�X?g-| .��/��	-ׄ��"xln&+�����^' '<��'��@�؟~a������#��?�\L 6�fްP��v hg~ �5Z�����2��>W�D�.�f���B��-�(Ldl�k� �[A���l��%N;Y;n�BQ�x ,L�D�U�j��y��W����F~-ꑅ�^�_����i�F����x���_H�p.i6�3ud8;x�l]�:����͈:��6a����v� b�M��RX8Z��0OI�Va�!�=���ew�o�>�%|�`5��7M�$k����(je��Q|Tn��w�Ǡ/�Ο�G� g���Ce��Q�B���]�CsW/W�{z�ՠ��� H0�d	1s7Mo`��з��t�h���muQ���w���\4��hҐ�!����=Ϊ�z)_kc0�y2�Z���O�ߛ��ݡ=��f��#Y�a� ;$:T���lz�Jwe5p��]�Ʌ��6�
�L��z��v^�'ӳ���~`;~.�>�5~d���\F���pv�����JtC���yL�-�Y�Ͻ�
�=��X�d��&���1�8'�(B��`��ҠɠH<L�� �C�$V��.�ͳ�0Yh<"|"&^T3o	����z/��\�u3�5:y�� �ɵ�5[��d�j�	���uJ�� 9v5��Z�B -�-k�Fc�͢���0��z�m5� i`T5��I%4�-�7v7ȹ@�X��T�Q��$A�r<�!���8�fK񓤨2���Q0E�-�,5 ��qM�n]�xLFR��}�Po6ZKL{<8�������+-!��>'�����`�Щ����o��7�e.Q
q�:��P�+�jq1���["'{�K�,��3�""L����b���	F�o�诺2t@�0�3�Ő���Ǡ�0���!�'����>���֐�&�Ni=�:\Q ��;򍊹� ��k�����;��s���n�L�X��M�c�Jj8.���+ 
X!zb�Ps�'�������ǰB҂�~�J�p�{���L^�A�T�5ۃa��PcI�3h�!6yY�@���=�@��~�f����-z\�߸1tR�O��/_���o4)���ݑe���/���/��~ZxJ�M�0�j�)�
������L:�	�<۪�Շ�|�{?�}V�51��$*�T0�"�y�P>��]��`&�V�+>��(�d�,aA��f+�k͡{�ؒ��G�����8�����ēf��0����!�Q��X�R<��[j�a,<DR�Ǚ�����`x@*�(���2?��Jh�ikX�G��f񈡅���gm�jX���棒�Ф�Q�KB�Zq-�	V%yH� �%�X*��|�a`��60��y,:wd\Ů�I(�ji��8�}��G��.��+���G\Or�+�/���i(�����h��Usa���/�u�7���Oh1�p�@D$lz���w�7}qE��4b�m|�2u��p��fܲ�6h�IdaoY��Q�8��e\��ݬA�������7��W%k��i兰X/M2�,VOW"���}v�u�ɕ|�Y�����`m��zm��~�,ߒR�O���8��wb�>���A6��O4Ͳ<�E�`��p��sG^�=Z�#���,��5"�/}�m��Y� "����f�)�!�����4�[�u�>���v�9��]Ɔ���{�6p�J8�00�X)l�}�.{}ǎ��e}��]Ø�(�	)ܽ���3���Y���_j81k3�F!+<0j�	�]$����9hV���!%\��ʴv�c(!t'[�	˯ilL�����IφM~�^��EA<� L�Ԟ���#+$�dG�WZ��%�!ft��rkĆ���XسA�B�3 VNO��8���w �*�i'(ukC%-��	�l��W{^��0#��	PmDS;�Fa6�`��H�ڽ�Q@=f�	M��H��^M,l'>���7~5Yo� �����e����� V{'�P�j����r����Pv+���I�*D�%6���"�Y�򏵷�p��y�M�M ��G�/�RՍ}Y�~O�����l�(;�m�a}�5	���"c�p�$G>�?˘q�&z��L��eE��D�0�j�:�-��VC��m@S`�b	���='�%�K 8�������,+܊P��	��}\ϲu���C��c�T���Tƚ��Bm�j���NGE޷��p��X�,�P���Z`��/��rt�'�.�aP뫐�oE����8�#MI���ñ��c��B�NV�)N˸^B�'�,�3�����J��%>DJS�p�ѻQ�]=��d��0��'mh1}z �w��G�-(#Nt��ҋ4�Yp� q�6@��,�̈́,�H��
q�:X���3� ,�!~p����ll��8�Yn\>=�?�qHx`&}���>�K�oM�_{L_=4���ڒ[�|�Z�p-�}0`���`_&l�N��	����u<�2
�=��m��b 	j��$���=ۆ�<%'��$�Xq���c�U{,)�A��y� ���4�`9��[��*�u=���f�O~�-�*��;������BEU��-��H.�_�7&`�h#z�5}k�Q���(�u�bL�{�%x��3_��L5}���/�5@]��&�b1Ʈ˘CR��Z�c��՝�3EK�^"-Ґ��Y�1�����C�p���b�����( ��>�m$*���j���    �C�6ɋE���E�YQ�������_�h"3��|ƕ684X�hϴ���`�
��E�DV-�Y��v����F#,n� VC�j8�u��r��z��bx/Q��A��c0f�V@��J&�{3�LB@��&D�~�k-e��P��s��A bh�w�*��i��:�`�/ЉV��v�{ED*~Pͩ �� ��o��cx�(n�S�LW�Y<L�CJ@ oy� ��_U��؟�̸��{~l��
y�P��.�j�Ab��n�fA��̞e�W�/��ɸ����an0�b���$)X��a6�L�(X��ͦzQ�c\O�p�Ѣ�r��D���-�E�tv��B�1�� @Z}� (�M&K^x�lf�����z�O_�>n�0C�b��|��`S�B"����E�0�bo�e����"�������D�c�/���G�v��W�9��]/bgC�X�o�����,�CUܛg9D��>�7�,������]�ލU��s_�!�����^�	$�0�ZN�%E��~�uw4Ð�E3�@�~��	{�OOQ�����/'2��,�3ry,z���o^��&b�	7	{�v<��˳=�Db�s-p���Us�� �RI"�J�"��z ��1v���@�<�Ϸ�t���*uWb^Ҕ�-��5��@O�YE�c�z�x\��wb����~	|U\Ƹ׮.;����j�:��eS�����Y��q�N�8�
�b3ώ�Z��̙<�h���/��<x1��?4�.��=n	���f�����uPn���/6���X� �AR�S�,�:--�N�X�Y�������~M���\^)��5I���j�*/�Wɗ�E2���-kEg��6j������FC9���/�w��1Q���˔���	��-�*��a,�%��:V�]]-,~%zֽ/���XI���"PAb"�
ְ
�+���7��YoЌ|��C�,�xn-�gn��в��8�П�h�J���;��k��N�G���e�!ۘ<��.d��#��W�*���X�t�d�����LqY���v�-�$�K�	@4]xT4w����f�o��D�&*��I�9>1��f.�RbG��`�i�T�lмL�> 6�´���g����rSp�#z&Ȭ��j�{}��x����L�Oɶ����r�_��m\�E�Ni� 
@��+�L��s�']�ڴf$N[�����{4{Ѓ��Ӏ���e7�rFV��� �)q�p�2�2�TK���Fx��CUM�ZO���ëQF���f'Hg~�B ,Gq� Z���*\Hy����_��Bv��T��1�3q����Pc�+�GnVm*����0Y��R��/pD�S6���EeO[�=���cy��9t��a�±��A@�3�˼ v^<T�Cy�bA���G0oW!V�;*�:�LR%D�FjB]l\B�b����{}����%�}5&�&�;C�V0��b��BW[q���C"S�ϵ�i`�fn�_���F5�����X;>,ށ�v[�H����]k	��rV�m.��P3,�G5�MY�l��Z{���}���%��+�-� �A�M�`w~���*V�#)F��ƞ�4���g��M��.�~��΋a����r�ǒ�,�W��Փ���'cJ�;��N���Q�e��c*:��ϲ�5C�_ŅV�N�c+u�_���3����͕Q��o��< O�G�x�+6��!=����9AP)���!�6wT�	�$26�y5<��Ђ�g�f�������������ovdu�^��!{\�~�Z`�`��5["��沉D�A?V0Y:2��ڥ%������g�Ġ�F ����F���8������C-`�N@�?]����';�`[�akw�;�0����WcAh1%B�@�Pv��X7���4�q�v�ھ攆�Ё�󧊝`�1��s�n���^șj����)=VYF��܆�	M�8��ӪM����3v�1XD��;�-Q���梼�����zC�4#��|]�{&�z.���	�
,�wjY�W�j�ˤ"Fx���}��a��y�/�A���N��JG�@���������ܸ6��j�}/t�:��<�L7�hL�zD�`��U p\��vJ2�L8�z�%�A0��9���p,�C����.9�]�F-@e�ku, O?��'s:>�����S��
X�1y�N��.*��El����1fB!�:rU�@ �����&AT�# ���O  ;l�{�~dB�����aH ��5.�����6�	R2gdkd��fk�z[� �b��}�:P�����,66}�;�N%ٵ�*ەe�jayA���\\��/�.�A��|S��p&�<����NL`��r�V�a��R�b����sa12�2u�{<�xo`� ���2�j�3<7 'V��pXF���ƚ���,c�`�~�	�߶^��:���������6ۭf�N/1�o\~=���eQ�6j��xX��ji���[a4�R��.�>#Ƽ�����m]�"!��rBq�Vͩ7�?L����i�~����!Sj��k��-�l�McB@�P6!o.{A���XFuVF��' ��.�ެ ��h�n
\��<h�b�fҕ�d/V����ja�+`��OP��'v�r?`[�J��Y$f��o�Ȏ��&XàQ��O8�Y3�<6Fkz��=��ӿ�h��&K63��2疈���\�$�/���n��3���%6��9v?�1��R����u�`+X��%b�F�8��^xLo�>�`5M��.X@�uS���G�C��j�v�Nd��&�����N'X����k_36e�ɔ����⛀Wm,i^y��8 ��\_���c!Oꕐ���½F���B�cV�:7%�L�KL14�Gq{���8f[n M���4X�?,�!�_qB�ysv"5t��,�Oc'�c�O�u7�8=��3���#QL�1�D"\<赁�&xG+�<92��p���i@i�kgJ ��1�z�`G�����#SM���p�ϊ�������*vX�4@���Tl�8O�0jx
�s��|���#�晟�j���+5��bj�+�1Û��c�F�yؾS	2�X���x�݈����V��|� �ׅ� �+B�������`�].���z_B�Gb&�g��tȶƬ�9��-L{p�_ea����dt�W�%V�Ao`�&γ�ٱ�m���6��f@d��!�@��A1���Z�~���!,+w�O\��kR\�׀Ƞ�M���bݐ����0��a)٨\�_ʗku���S���Ю0���X?ĕ�+q�+����q0,��x�����Lh|JNq�����ߏ�9���ӀI��7,�:���;J�YfEN��,������Y>���O�h�X+`C�}/ֽ�����А��l�@��.|��H����sl��zYN� ���4h�K(�v 8|�^ =�	�,�aF2�j9�UC��='�G��2�P��vb#�`U��(v�c����Ϸ,��RED5,l��h�¦i�l��:��W4Y^��p���z��NP��h��$����T��s&�,��<v�dU��:A��r�CR�$BP�j�D܆G8h�n��e[,�c2���˕����l�pi���bh�(F{�Xʑ�EZ��<�hҢp�S�'-�c���.s����Yw��,�8<��Ƌr�&K֓��Z��o[Oley�Ӷ4I�-������Ǚ#�����vH_M[p��	6v�%�"r��k�XM���w`�����4�X�����07 �4s��&��&Z�x��=��\I�M�o%�ֿw=�x�;�:+�eR�]ݒזBG�ذk��!r�D���<p洈D�ϴ,��Q�fO�'!�;F�9�OǑAN4�<=t
r�l��0�X˚�df�U:�g�,��N�h�0�n�D�Ӯ� ���I(��h��[gG3Ӄ�m���G�cO�K�浶jxJTr��*Q_�ـ^�ץ`w%b�2    ý��j�p�* ́)�;�߳R��^�j�CH����>�(���%��6y���a��.H�sV�������3�t2�E���RT��Y��|�ޚ�L�c��oIӶw���ݮ��e�6������D��}q����Ū�V���l������DKAyŷ�~?T;���WL�u����ꚅ��8U����m�ގ� |�*2�`v>J̃LK;QM�v�.�Gp�腯������(t�W% ���l��y�Bn���DOQ��(O�|P�C6�!Ywn/�����`&L��J��g�H6e���Z�/O=4S��;���hi�U�0|�9QQ��K�7��Z�����d@���Q]{�Ü-���B�p�Qfc��)��]a�|S�l:�h!����/���g R�Ϛ�oG����.dx�Sэ���ђ\�\s��M���p��][Ӡ��^+�vG��xov�@Q�hk"S�ƿ2lg�ϖ�_{��WAC|�ݕ{�,����G���Cnaԫ�E��]/���0��s��,Mq���j���-���Y
����1G~<��>'�=��
0��:�e/7	m�a��K=���L��wVǹ\� �|s
�ێ��D�pg�����F$��py��RU'�y��h1[\�lhY��l��x�S� &��:��`1Y��c�BG��#���"������f�4�g�Č��s���cʜp�qz��S&0�����٘�1����xE �d�A$1	ln�� � �=���V$8.t#�tK����/�Ҳ7e��p��=���tŬ
��/�{<a����g�O���<��D�f;%x_�(olVǞ`Q~�g"3��-�B��:p�C��W��X�l�mp�6V�l5�V�MN-Dy���X�dck�Vހ�f/��s�nN([�՛�pD��ګhF7;
�� ��M7����U�)P>`.r��)�s�HXsv^E]ZV���6�+�na�ݎGoBm�����3�h������#8�)~�%�����lQ ����F�t��[�Q�zd�&��=
�A7Y�e�ǖ*s�,Yx�M���*w�rF�������i��Q�p��6�U��j���*�qT�e7oc��g�v�=�V=U�d���ቐN�U��D
�s�@���̣my~�K��D�܎"�'�_���{r��H���Lc8N���� �+ۅ�hŦ$����*v?r�$�)}Axcq����T��&��|l��́S0�o{�Q ���GcZ�)��n~�P'�jN3�Ys�>���B�� 3i~�MJ�e�	�Y���	wv�a�Ѿ��b��e��j�?��%�o_G����2e��u�S91���EF����w o�w�Ǉ�ӑ��s*��[�3q��Ie�� ��k1/�ô^�6�l��56�"��xW�!.��U�ی��u6�7�~F�́tִ?�.ZH����yԆѼ����l���c8|��R�C�l��O0���uA_�ޞoZ�P��+7;��5@X��-�ߨ��� �W��X
�0&��#ľ��s�ٟu:��qRs���if�\��m�,�
NY�I��$�#��h�ʔ��N�De�˶����`g�E���	IC�7b�]�'�vr�R���̲�3f�ń#5Yl�a���0S��¡-z������kV�[ �0�ݕ�_�@�_�i���B�ٶG�h���A��i?�9����[v�[T��j��:�$;}�}��5��\w��Y$��rY�a�3��B�-�0C��s���d�h���a{���rv�\/"���]!J{��K�`ȱ4�)#��LOl^�R����b�҂�z�7�\x���ͦŎn���jn�\4�1=�L#��[)�Q^"dM'�'�^�ˮ���E|�{%GD��<��b�P��8�a�^ꋕ����V_.[�<�<%��
��D���PD�Vb�CPEӪ`i�dyq["�\�?i��>r���>Y_���!YJ���J��h�
7|�̡Ն �����a3����|��v�d�7�
��[�;��z�����m�u�$�jKAh���%Ù�r�/�;���R�t>��V��y�}m���l�_�C3�_VǼf�a�.��D ��G��mJm_U�m�c�}6��n'�7�>,��(N iCso�J8�?��Be���
�=�0A*�� }4�V�����}۰) �b��db��61���%�i�q�g;�	�l�9�`�I��&�_��En5��Gj�����X���2CZ��C��F vo�>Ξ�(�CCq[��0�SY Hx�����C�$�E��Q]2h��"���0��7[�y8ج���}b��47����qy�1lUv��ٲ�nFt�����<���ـ0O��\�D|íN
���Ǿ���m;��7 	�I��z~��8DrN�g�������Y��k�tL��ݳ��6�к�⁣�0y �q��	���x�(ޛ����3t|Z�!��
ض�y6jg�u��,�ƅx��i��]J�2t�3),���X0�1�2�n��G/���B�̎���Fgc�c����*!�+F��2���;�+��P2����Z5`������' %Wǅ-�ې6'��-1\Ã���]�d�c����ml<�%�,�� +_kx��8�����O�������m�M���ǆ��#R��:����E�vP1���:|�Z��M��Ԥ��>���y �Yc�9������;��}��c⟃`��XV�x,�H>k�Ƣdj
�ԉ�A2�~M����)��`��A �[
Q�iE�����Ho�*�t��l�s�ﻭQ�6��)��p�G1J�,l�7��;gm:�~�ov���q�E��0x5�7���9���>f����_{��{B�Xۊ\�~� 5<���YoHN��>�a����{g��	�6�(�.X���_�l9;Ҟ�le���1��j�K�3El���xH����O�d�T
K��Cp������8��=���p��U�0j���M;��>Z[v�4��& ۰�)�k��쟖�/������X�a�����l
����>�q�ԸV.»��Op��u=�2��m�/A�@� �����&�+�	`:���(9Y�Õw����tՉ�'�43gV<��7�u�)~j3x�H�NaPn�,���u����g�P�m���2�<���o��87�0ۏ��&l����*�9����Bӑf�\AN	1�-9�3�'�󎁿�8��u�ju؇�3�z���LZ�s
�c�P��d5�f}}5gX���.휟���;D��x�I�j5���j�Mz��Yh����ؾ�i̓�l1�G!/�}��� 0 �� y�'�G��h�|2��=�ro�)��>����4��!Ih�������,]$��H����}�{q�W�(�����U0�Yـ`���) ���mL�=/�&Z���,yv`!B��&{�?Jim"��T5��c����:R;r}�fY<���0�U��Dy�x(�
d��p�*{l�r1��)�Zau_O,^72�t(S��onvr,�sᛓ�`7`e��~[:/�4�� ue����@���$ڬ���)��YX[�D����7-����	0�g��j\M�B���F��q�7����o�>Ƴ =���.6F�D,�}	�k�B�=��m�l�}Dal�c��t���� 4�cl�O���۾zL'���6�NH�Wf�A?M�o�y��0 ��Ry��u�w1/�9bY	9�|�>�ˣE�/�ln��	�e;��p�,��-9�9�|-����~��ik֩9*��ڰqě�	"��xd�Z� ���5��͋���X+�/,�������˝<NOz%E/T�a�����9A5��0(���D����8�<#{1N�	����K�Py�ai�����l������0����V"���uD�MZ�O���T%�M�$�+f�J�_FO1a5�ex>��Qb8���!�?,�El�N����a�<>7a��P� 9�&����o+��duBq� �  ���{�)r(�c>a���Ω�����/�� �z-7׫�!R��x@��-�*(�E�'�0탑�PĤ��$Y�F|��yZu/�q��$Y��%��Y�h|���>��O��E�����mKӲ�ņe�*n�~�c���8(Y����|~�X�Nw;��i �m��/���PK��1���|M�|�'2D~B�p��Y���8h$��+s�j��(�`���J���#wc@���uǈq�k�K��µ��q.��·�dc�Gd��b���,u9�׮��S~���RaF��aɎ�B9�l��Sȱ��M; x��ۋGb��C\6DQ�ھY�a;�ϖ��p0�ax*1���QҎ,st��p$�-_��{��S���Aq��	���j��J���z0g.�׮nh�|�X6H���cAq��y@BB�cJ�Y�
��r��aD�n�c/�M,?M�zN>�EU�QA�M*_Jg{z�	��A��M���Xg��Mr�'���4�ҹ���>PȺ�m%��~�!�v�;k���,�#J+�ޒ���Ol���ii����#&���k8fy�x�	 gK:��4L5�p�%8GB��y��3?`d��d���V�h�i6�0`����2\�,Dl�u��LDa_�!!'����7P���
)}�pt�����-��n̂g�z���3amu>M����������j�
��q����o�+��G�����z�t ��^��}�K���_���e����]ifZ��F
<�?P F8��R��&a��;�I��n���e2��vNKɮuG�:l�؅�^��o��7��>�n�j �t��H��ћ��t����P˷؍jj�cT��8����N	�N���yX�����	�3�T��v<�s�����	AU�?3��1�����K�
��3����e֯��j��x��ped�w��`�%���7�v4z���.��� �`#>��Y" �ύ�*���)o�r�0� �-�%�X@�}ޒ��l��|�Fb�Y���l���y�R�J��mk��� ��fX��+Ϗ��3���u��������mr����B�'-�Ռ` ��eGaM�.\��a�욳� ą���i����c6�����+�%f> �!�����q
���W$���oF��j��:�N�)BB���4�����fb`�İ��u𯓒:He�5�����8�F*m���nV`�����:W��8�'i־��X�S�������k���T�Y|,&M�D2�'Rt���G9�w'J{4�6_�� ��Sݛ#��Zq$�7b?��gV,��;��(�o�?P�Ł��X�<Gi�d����o�ş|����ɞ�=�be%���q���!9Ы��ʺ�y�ƴqL7��)�_JQZ�,����S��e2���Q�v��W
�#�G0��*t򅔁מ�(�=xn��,�<q}g">��;
X�b<�'X�-�b����!:1Y$�034`����p�>�}h�O��� ��Q�y��/�f�x�wĔ��`q��k�ظ�a���G/��j}�A[Tkp,�#ntc�?�s����0,c�U��fF������	�e��>��E5~�w��Z]i�aЦ��ٕdkB]v>�@ܫ˧ctg���l��I�&n�@G��`�z��M����@��/����'\j���or�����~��M��������0������E(�x�?��ϟ��O��o~���������      g   {   x�3�(J<�<Q�����b���bNK�?N�Լ��|ϒĬҤ�9��M��,8��S�R|�K�R�/�WHITp�/.I��4232�t*�51��m�%��P�bC3�m����� �/]�      i      x���K�n˒��>�+h����e��C�Ru�j(�,Y����s��w�*	��^�9k�5�1FfF��Ȉ.�����_���������_B|���=�����oW�o��������o��/������O�ٿ������W����ӿ����������ӿ�_���o���g����������?��*��˿���ƿ����Z}��b����jKOܱ<��?��Vl�Ƙ��+������{I\=,n}�h�5��_{Ư����x���0
N��C>y�Iy�/���s=��b�3�\c�.e�v�����u��r����
���T���E�Yx?��\�k���W�]�9���٤W��o��;�����w�y���O�z>O�������׿�8����Op~���g����i�%f�����}�/�OcF�����/a?�??x��z��/��������܋�a�\ļ��:��'x��n~�g��P�v��U�l����fŔRa�7��ݍ�mf�~ϊ=�F�җ�>���pO���<����^�����}��i�����Ҟ�5K�ϽL��x���)�����;���ur��IOҬ^z�\�JA���HfLϿا�Ϗ#�������^j�����i�����rBt�<+��r�G6���s���T������?�%Zr��#��[q� �x��^p,��R,Ї]`U�͎�7��g('����uӑ�C����]����"}�t5k`�Bc�}%��
m�90�F����/���&�~�o��{;�F��	Uu�e|o����%jd~Jf=~;�ם�()jOXk��-Q�7�����X��!��G���U����%�P�wm��Y������hA�UV�ݦ��i���a���'���_��π��1����Z�;�x����`��p>�Dς53��=W��R�����y�oX�;��zY
@�	�"���=�<����D[�g��z{�k.��Wۭ��֧���� �)hm�8>�G��{��~/r�����P��st�|p�.�_��5/����?G�s���G��O�?����;=v��mO_��y�Q�?���?����yei��B�i���{��F{暫�Z�Ǣ�3�A�"W��f�����|Ŧ�L�_i%LZ8<�'�}�ܩ�Pbe�Y�s�2��G`��t�s55��M��ܝ�?�?�#V���Msϟ#��7�H�?���#T W�e��������i'�mP�+�J��F�}��z��=�6��z��V=9���H����mͳKqe�������\�y������,�ct�O?��Sf>ܞriד
���$|���,;턏>����d�ɬqlԨϙ~���C���0m,}xf9#AN��:�i5��3��g�=\ˋ��&�8�%�W+���?�Zy3��i�g�)�\���y����3���|��Mq�Vg�=��)3�;�l��y��}j�4 �_0O�o����z����B?iC⾻��ǁ�S7Ac��^%�Y`\��!���6�����
X����<%�']���z{2�`��QW��j]�#���,_f�Oj-τ'0��+ �)q@V��݁0A����".ͺ��0�`�*��tB:�3l������d��iW��Ln�[vz>A��ׇ+6�W�%��y@
��x��T���W����Y��� �:�me�]�L�_����l%��*��~��x:�K��_�ҙ���T��E���_����?X�g�>���4����	�'�u~���I����ǹ-* @1�m���췂�)߸sq���>yq#�jJn�;z�G��>���ׁG3��n:�X�E��]���ڄ��9�{���w�qd�h��f�;��#.ʙY��f%O��'W�%`���{2V}��N:w���o���?� �l3D�v2�'vV{��������s�k�ܷ<K[<?�,ʥ\J�,���(��W���Xl��Z
���#)�Y
�Z�a`�r �}� �ˌ,yB*��LX���.:�n���{3�r%$-&_;�N��F�1���#Zâ?i��R���HtuS��>}0^�؟�41˕�wŽ�|�x(��ۈ����[Ǌ���t���m�;nsQd��O����M�郾(�XA�;��*�u.ۀ�G�!!ٱî�]�bn/���V# ��H�=C��˥y���|�B)��Ko$�OKP�is1(�����;��|4%
�w�Y��8�(�iS��6�fK6����T�����0�م<Y��.#֥�X7B�z�&����1'��JM�땑�q�G��i�jCُ$b�_ˇ���rcƁ�|Fwv�%1C	 ��~$Y���j�h#^X��w'��jC�������ՠK���k�h��;H�Q谅�^L8���
Ȅ��^R
LY�jφ�i��Ib?��k�.����a'�@�wa����K�<%]��kWt�RC6��s=q�CBb)���(ӝ`����gn��Z��*��4Z��S��0+�9���D����" �"��[4������#AL}�pqIt�@[0k�w�	$�_�%��t<��ب���If�@R"8���kn��U�i�EVdBAo~Po��9J�A�t_ޝ�o�vث����t@P�9�)��#�&^zk0�0���/xH��s�c���y0+O�pM0��9^�E02�瑍�Ę�T3�����n���*X,a�ә#�?��3�xT$%ya������l�	�w���sdwi�F��tD
����19��˾,T���ʥ�M��/�I�.c��/���	��֭%P��Q��\ˬ�n>�k�N�����öK���z�t�� %��"́=\ |�^�
#L@/t�,#b�Xg�8�)g!7��3�7*.�.Pz�농 Y�=���;ַ�G'43��`i����� j�f��	.�[<V�	�g$y�@������P�0L"����x6&:W�,aK��"��M�}��"����j��oQ� E�,���0���@�!��O���ѻ��_A�@@4
z�P���Q�F{��*��.��V��Hr����%���̒i��2&��G9�+�*`Y���1�<��Sj�j<�i+���I㡒����ދt8�cf f֋,���@"�?���;�Q%��-C��.�6�P�v�M�g;1�p1B>�|��<�R��������^�%^�l2��x|���'�q�,��U>����@��"HgC��6�6�s� uW���6��D��&�I"?�����0|���&��~F�Җ��wxVƝ�\�w��@&H����.����dP�]p,%��0 ��wg�{�*%�3S]�0�Qq`X7�?�ݡw�Y/���=������b�WB�$!��z��} E�¤BG8�A����L�9I��v�=��.C�Af&0'��3�(.�	�$洴�ȍ���,��3eO���Ɓa��M\kTu��d�#nCjƔ'&'����s_ �"p	@o�g��C�C�UI4��X(e�~����Qum&�����)?�P��H� f<�D��E��I��w`�����)�
�Õ�/c!�� ܠ4���;���Cåк�,�����au�I�!e��������8�
����2F�x��f���Q6<g�?IW��U *ɥ�c�IۣÂv��D}��[2N�	�9>k��(��gm�D�"3f��|c�C���T0@Xx�r<_�#���hF��y-��.z>@��A�T�\�K����%V
:�T���ݏ�T�A@g��*e���< �i�o�kĂ��Rdmq���� @k�&�v��5`g�����I���e���V� ow�	f��PJ�z\QS��)�����nz�����Q����lEc�X�찯.����(
�|v��kW v4O����K�\��JD��%/�'��c�E[�R�[B��p��$��Ұ�~�|�v���|Ŵ�rI@��M7�Fa[ThZt�٢d#�ܚ�aW�z���l��MF2 ��ލ;9Fc    �/� uMK4F���L>V��#��/����R��K����t���W8,�����S��5��1�/t�ez6x�+����4R2�g,��[��ב���b6!)�d�'y�>-���6��;5ˍ�]�ʷ���Pq}�� `ː�<����w��c�A��T�{�����|��P�}),��.��ާ(�� p��t�Y���H{�\k��I�i
�a#�嘀^�����J�b܅��L���杼KED䍜�1R�'Ӆ�R��΋�;,Ŝ�4�"���D%�~�Bl�l�16�����4.샹��*����ۭ˸�D0�h�MmFI�B �g|�f���F9Kq����o4_���٧��'�9��������'Qb�=Ty�� �]�}�ر���xV����ĩ���w�\T��,~@h�aB���0��<$����)I����ѷ�'�E��$
� l�`pLP	I|�P�f;�����qa��Y)6�������W�CLt�fI�%,�gi��?4ŏ?3�M���h���g���-�Σ�{	X�jN2Y��{��--��A���wQ>NH�I���M'
�F���/�H�E��~GK�/Z�A�$��l:p���w'	�e��J6�N��p�r��	����2Z��?	�xD��Ѩ�|�]`���s�Q�"n9 �������lo�ַw��wU�\V��I���	lʬ ���K��'�K�m=�m��]����L�7��Q�f��� ���
~5~`���H͡P���9b�ыmɕ_:�p��Ғ����&��x�x��S���fl �hA܇v%�ap�)V�/�E�
^HgxQ��������BT�I�ǵg��Q��jm���E2\	������e�%Oe�3� �����v����偰�j���Q$atA���{�� U_��*p�5�oj��a�bꏎ�q��&vq���~f�ja�d����.�-�
|C�eX���E���@�_~»;�"�~a�)��dF�E>R�Ε	��������+ ���>Z����\ʩ�۸�{�q]+��ة|�I������B�q����`�۞V����4�*	x�u}�h�3xb%AF��t~�AE�4/�,�z΃Ž���щh煮՘�O�S�jL�4X`���N9�*�9@ A1G������F�V��#���G���	@f�sf��-\K��+��;��P�����枕�Z%ǆ�:m��zQ�]� ��D�)����Z�����¾�e�
������7��'����3+��I��4�=� p��`CEo�u6�+��H74�������c϶��Lr}��)���!���Ey���%M��XFl#Zw�)�l1���YJ����%?G�(ƛ�C�NT�%v㈪h	xݔ���9��Z7��]�K�FBߢ�C����-}vr:b������ID �����V�F@�A��� ����ȩ�o���elU�p͌�$� <|~i�.m�b�Q����Q;JǣV�#k�:K;:c�ixb�!*� �=P�Y}�FJ����D`���
i���dw\<��s���Y�>*�����m4D�X��>��P���r���uޘUa%9�3��'bj�6t�%�N��$�������nH	�Y^m���!�>�W����e�KY��W7p[PY!��?�0�Qhq��Q3#`�x�~�tA�)���bަ>��թL�^�f�x�'ƛ��6�T䑳jtR���t<��Їm[%����>u�XZ%��9,���t@��������ym��l��;wwRhgE	Xv����~��e�t�b�/��W�����ZI�jcu�M�ۢOOvx��K8���u�y�_�.s�f��s<et���`G�|��'�;����N21K�����'�
-�/t���'y���0�2FT.�����`�T�ז{�?���H�c�ˤ���� �a��"4&�6��0
����3n�^�i�2��r�01���C���� �M�Nj�2����	�������KI� ��I�
m����g��	6>� m*�]=�o��l��Q����*��'=]b�`~씯E�+e���<[�����\����}�Xb���Dk  �ҁc:� ��sl:6n��T�^�j��H�����'���]~��#5�+�O�\]I�ʁF^��
�����g��րb�ʽ�e��bM���Ɖ�"CP'>I���t�u(��Y�Vl4z㔝xrz�X3	󊞱/c��xE�,'��o'Φ+�Mh�	g�jQ"����ȕ�6�� �Vƚa��\llq f��L�;V���&�=�^SVZaV�	C��X6�����^p�t7��O6�P;��* �-1?�C7	�q��T���Kx��5Su<@�ʢ��j��}F%������;�������ZET�%��}��_�����]iǵ��2�e%$!0��B) -s����o��D J�< �������Im8[짰��Y}�Ѫ���K��)!��Oq�T���X�ѺVt={ Q�x�X-�=��Tu���L��L3��*�� ���s�%��~V�X��.*�N%�<�	�sE�
|�D�׊�"��$��Ci��_\zK0���Bb������<���_�>���
��1�?̈��?�u�I�OU�K'0B�Ώ��Q�����*^>qz�<o�~�����������0]I����z����$�����Q�V�+L���~x��h��*����)�W��VG�=}����{&�b�bZ>�E�0����p�'�`Ulku�&h�P�KӕI^Lw�N�I{��P�NP4ϛW?3�Y�ŷ�KA�, <7��̸�ɇ��u��GV�u�ө�ɨ}�W��1o����j4uJ��+U��G��9.�A�-����7�YE�"d��嚙=��jL%݈�B���౳�o�'n��߯�G��U����޹X"
�jg$�j}�7���>���L�Pg[�Ƚ��Q.Q!����&�W�����f�] \&*ͤ�0��&�\+��sdfd�����tS����6��%���J�ǎ=K뙝+B�G�(Y':rؼ[�Ehj����Q
4��p�X��%Odu�SuF�tE/���ғ�fq0����\��=�&{��8��l��b�qJ��)�͢]�s\�nT�u��'*��������pO�k���!��\ñ�.i��ih�Ym!�5��G8٦P�+��LG?��?;� ���r���E���&;�N����i�=m��R���J�����,��A�@�Aq���4�v��k;NIY�r:���Qt3V��/������Q���Y����W��T	�P���W�A�(��������WZ^�ʽ:9���->�Lʱ	~�#8�˕e.�V ���"wюKs��Y��u3kC&V8ۥ,(U�h��Z2y�k�@�K� ��ٻ���VßL�1��sjH�`���ܲ��_��Qd�&qh��(�i�wO�ľ ,��I��58^���NW�O���T���Y�8k>��7Zh�>��߼�l��~��R��3�� w�­�|bGK�#'��x�dYe �p����U���l���r\tq��4E�E�*�ٔ0�Q���}d�o9�X������*�rk+����Z�|�����6w��Wi�����}~�o(3�1)�04~��.����04%Q�T��<S�3-e�V�(��j7���W.��r)?R�:��B:�I,˶Z�ݬ�K�LH�u�tP�pTY
ұ�^g:X>|R��YO��1���� �K9�'kQ�:sPYL<޽<�+ࣳ-��رHӳ�1�K��ihZ2���(����H�(���ӏP�GJ��X�LQ-��W��q��yV���9��Q�h���v����\bNL�oPHk<ϫu��� a����y�9j��ms
����5˩�x.�v���=},����VEU� e'h����Ub0���f���q� Mն>�K��3J�}��D�@����	��@    
l"�8�����4��M�&0�,�Qŉ�F=��i�Gy:��VU�<ԩ��kO/�o�h�sݟ)˚��z	�ć٨�:���W�E��SB���a�P��;U%�������V����
qFu��7�b��TKU��ƫ7�s�P���Ά���P����J?�4O�[/� �q/<�D�w��ځP-;��^��-B&9A��?��������uU�}��g�ʄ2d��-`8mVzmRV�����o�(O����H6O��T�cQ�	�q�Q�JmQ�B���P���'Y�� ޾G���3tD^��T/�T�+?SŸ�YT��/SS�ő�ff�y
ck/2�Ac��Q�&e��S^��6k��q_�J�����Q�pP�b���^��=P^��;@4��9���)M%�Dp띉�;4K�U�'M�7"4,7���Sl���\�,�&J`��g�J���J��r��p�GQ�Q����?L�Z[iW��K����]�uY-J���ǂ˪��+�
Mɖ~K�է��̇y-�<����Zq�n�=��x:'pIx{������N~m��Yxӂ5�+�9���F�=�U|;�p�t.��{"n��*�����_��^�y�륶qWTۭ�Ԯ�x3�//�s�T΄t´o-�5�o���2�aߏ"�i5dR��K	�P,���x%$��t!��m�f�A$,K٧�����#���b�ơ=�/ؑ�U⌙������T$*��5�*��8:a�*~��}r��Y�B�f���HF�>��	<J�ÓU^ދ��]ɒ<`���d�q��z�(�BGlo���
q��lf�Ѕ���o���ћ���u�)�_��8�z���[�ARGp"��Y�ԁ�H�G/]2��Ⱥn+*S��z��"G�a�YD��z�W�8Ht��ADHt�߲rf����ӓΛ�΢A�+���te q��;;����S�q�G�?�*\�+^/����V�i��+�����S)߳�ϳ�Pp�U�2 ��K��PF��Œ���-��cLU0���J��˥LPZ"6e��F�y���֍�Ε���YvL����E���5������V��� !�U~��٦�XO�1�o��^_�Bݟ|�z���r�+��Y_�|����r/�f�Eb���Ui p�;nU����}x׫����$�V�S� �`��FҪ|U�+�5�aр�� ;����S��C_c�;��!!v����y�։�S�o�a6�El�#�뗧��Ȼ�0�n�SA�KўkRϠ`*�FM�?����ʁrg9|93��g�O˩���j�~߽����U4\�eG�5���5T���<�.��^�〰�T��|�'="��j�Y)��M�d�cF�|��<i.�R��c9`�Q�,���ќQ{�+ ���Vڴ4Ĳ8����`�0�~�u���Uw:����A^1�cd ������7��"B׿i �������}h������T;��_��@��^p2'���:�����0\��Y��:U3�B�S�"͔rQeɘ� ��u)Sy�����0Ϻ�%��,��Ѭ$Gy�\�^�1\S�p�=��GX���W�Ue��y�쬺�a��O�iH�����;�'�w�M/�]��&�bQ@���o�TaY�{0�-�p���ӕ_2�ZF�޲4lR8�nQZ��f������/U(	)~$+�k�0]p�J�D����ye���E��Q����[�!�J&T��#�ΈݪB�� I?Z�Ÿ	S�,옮��?G����P���?<c�Q=���#=;�4�L�[��g8Z�T.�����P�?鱞��U�0.�Q}�0�������*~��;^�I8�����X4���ʫ��zqh~n�^X��|�� �(�}��V�\M��i��P�0=�U5�5[�~sO�ǿ���3Dd�E�oe�ek����$�+�=\�\ݸD��Ut��P�]�fhsˣs��]u���rE+ה��� ɓ;/�y���Q�@~����g�����wE88���{|]utRx5:�>�cn=���9�y�`�bq���g�+]�Iy���	� .�\TE�LC��9���g��s���i�^^��2�'�.���1����2��~��JFl���3�9L�;�ڭ	��K��T�!�[X�ۯl`��C��5��l�v j"#������I�R'��n<����':�I���D�nT"�A�	���t�sK���q
��5�v?EŜ�Z��,T�]�Ǣ�]�Z�����W�	�����LT�tu&���
�<E&��j{ 2ݠ��b'�@��ʇ�&+���қ�䔀�a�T.�e���-�r����n�5�Qh�g�B���/5Y���\�3��]�{�wC7n�V�n9�w]��r�3W? �-5�,v"x6�b[�=o���7�Ms9���bW%�ss~n����8?+���.�)ú��f��K-�d2�����ʷ�W�I�W������A���Ծ"�$lՅZ���c��{��P�ɑ��n,T�|�J�0f������+����x|����h�W�Q�Z������=*�x)~�u8\d`P.i��Y�V��0U�%�,�~(<j~�T�n:��oס�n/y J�T� Khv���D�«ㄻ����D����nj��%P31�X
�
�{�
�/�M6��W!��]O0*�6_f�$*EX{�-SS͗�NY�L\Z5TP�֭%�A&I��f����:ʍ�R��N�dWʵ�Y-P��q��� e/*�IJ6���;3�h����+�����_�c�f-�P��u�?����U|��x�.�sM�w8�H�\Q{���t��&Uӭ����%4�+/U ����l�$+��euPF岁��͠�E	5���;���[
��V���y���@"5�m�_oJw�I�f��S������(�"A)hc�7��x�W�dP�(^?i�5of����!���[֨ͫ�д�r�r����T4����Q��Y��.��5�A�yP�;}NC�Y�5D�b^!���-�ZO.�֨�
3��x�G3KҺ����L�!������5%K+�.���R~���+'�
N�Ԁf��<U�fw�G��
�`@�d��>���Ѵį�C}=�R/IjN�2�q]M�p�wn�$Y�
0}�V�;V��Xh1�~m�G���8���	�ۼ%�p?^{�y@B5uR�~U6�u>��r�S_^��N��P��'�r�P���a��Ť͠�{�P�^t�6~��'ũ�������"L��K��U6ź�l���b:�gA28����?�����S_�Y�*3��!w*��(��?[m,�2Ú)�K" �b�7���&J����nn�:��B�[g|O��lA���GH�Z	�=���]�ݘ���z�����e{�֫/~���F,�atc]XA���b����L�S6�D�xv7R{< a�{U���n��a�(:��hvEzŏ@�LE��]o]���JޝչHC��|u�UO��JF�����;k�f'�B��)j��jI�ױ��H�z�O�`�;dv���s��ܝ������ц^e��F�v�K��U��N[�¤�G}�
u<˘+[��h:Izgk��,�Ԟ-c��w��Z�9��(If�ф�V?���n���+x����}�����%�n|�k���W�\K�X��J:-R��ϙݯߩb��g�9�����7���\����'? �ߔD�\4��3��B�&�s�v�s�H�3��:��S�I�~.�������l���S�䘡e�ӻ��7v)�'[��C�ԧ��Z�VV� ��-QS��ۖ
�9yBǪ|� ����ތP���2}�����JRz�`����ܨt����Z1�yΦ|i\;5ɲ�q������`d�-���%�ت�'���8&Լ�f��j߲�Q�����<�f� >ӷ{b����@�c��+��]9�H�>����.�*�*�՘�d�����XlA����cl=�aY���/�k�d�XD�d��Q���������gG�����ʑ̤$��5Lua�WS��E�iE�ǧ�:X�Tq���X����kV3�2�����,���qϛ�6x��3�w� a  !7��ū2|�_���̓X�/�y�v[AR��}����h�O-���>3�Zk�*�b]�=�;�Z:i�����;U�P���Co�������uƞN��F)�o���`�A�5�;~���ϝS)�
�d'Y:�r`gSE��1��>���e��+� d�]����r�B?wa��,�q�zVW�*�6@]8xpJ�H�"<x���]Ek���8�f.q�7��?���2'ü��2�Ս;��"U�
��\���	p��>��{�I�p��>I��F}���Qg����,:ʊ��/�׹4���+C�7�w���#���D��5qm꙱�N�Z�җO�o~��U�����%4'A��9�c��A�5m�y͟9=ZMܖ��6<�*Wb�~ʶ�f��^j���sv�]`����_MŐJ�j��kP�%L��ܦ�K����.���}ˈw쑌�f�9�)D��p[���*W���b����g@�
�<�4��?��d�L��f���aJ����A�OsQ����Le�pwxuO���4���9|	�3��E��u�����J������K�f�̓�b�Et��ݑ�wW�u��I���j�����0OSNgS��#���Z�� �;��y��X�S���o��8gTe�����l_�m6[+�������;�yK�c:^xO�e�+a ���\��&�;�Q��V��Խ���E�\��x��\�RyQ|��~A�>��\��Ȼd��n�7�E�,,&u��yw���hg��:d�䪅�l�D�"]��T�������y�����ݭGobS9�S��._���#�F_O�jc%Bzj?Ʒڙ�� ����^���xZ=
�����t:~�N�>L
Xi��Lw%��P
pS_5�X<f�=��~����=������G��֌��:���؊���(S�!��t�K�(�*��Y�ZK+���/ �;�����'�v�^�)��U��P��kWγ�Xg`U��3w9��l�2��-_ڻ��S����)?>������d����L[������z�UD_z��tuU�uF�t{gh��\V��<v�| <vN��}��>l��0��ň*P�XxX�l���<V�զ�K�[��kU�����
*�"#�D��@Xpϯ��ԥ|���&d �t�����C��ͺ��/j��[N��D�{r��־r�ά��� CM�Bu����[��e��V4;N����Y{Uk�)�)��۫n����T��;�T�^��ʋQ�?~�ke�]ˢ�g�����&z��V�ª�(-����e({�h��6�сQ��j�/r��;���u\|�)o4ƿ�>��W��`G� �At���Q�ix���r�����*���e-_�՗UM'E\ו�ơС�E~���a�G�^���Ϭjقu���?s����գ���H��}��u0�������"kgM�
6!��6�xɏaZ�Y�2�v��N$��eL���?Ἲx"G��UWq^ʌm!,��&j��W�jFy{ŧ�s��_(Ĭ�՘l81���Uṯ��\񷜁� υ��&h�8�6W�����7[	��(��C4��)���ԉ[��W��k5�EO�
��G��K�#Z/��4E��#�;�u�Ώ*�.��fH��2 V���팪rf^	�lٛ2"�ҟ,�{�T�Q(��՘J�� ���K�<[�t�=��O���8���/�?�X{N(�On�Ēv�٩�։��z5]���Tk���f��:�I��ݳ�u��VT?y�Ԑ��"6�]��,xI�=GЬ[(ɐ�s�.�:�bFR�J�R�-�[ܥ�����vG��A�EO��Ŧֽx�2zo}D�8D3ҩ��O�=�p�#C�V<�]��yE^��]� "u9S��x��e�*��B����.�K��vUv!6�=Fhԩc�NE��j">ӑ�������)M����t�+�]�2ۼR�(�|�W�J�ь4�/m̏(g��??M��Q��+�y�}WERv������Nm㞫�݁Ke^����΢q��%o��S!��~�`��D#�w�h%.��5XrQFT�k�.�*ȡx-K�۪u��84ƴ�z]-���^z��[�yi�w�F�-C�$	������&�ӕ.�V��ր׵�GoF���f�v\�:},wyW۹>���S��URD��T���CeR������vZ���.�qF0:���SMԉ��s�[���>��7L&�ľ���v`�~kYG�'  �g�9A,���_ps�;�RNs�i��`�X��6����*�|�vw(��n����G)����m�e�n6}�֧x>�ʆ�1�g,�k��b�]�gR�J@:q&�}�K/����q�~|co޼���Z\��[S���s�s9
FEo9��ל����J���K%9{�]%������>~�tX�d�����b�j�pVBI�Z)����w�ؙ�B��٫�R����̶rڢ
ؾ�>��(3���� �_�P�z�٭Q�zgɭnT����U) $Wrٸ�9R%��x���T���Ѡ��Ɛ0��Ƈ�+�������6�a��~�~{�Yo���
wd`��ϔG�N�Ҳx�U)������iZ�;U9S�ϊZ�T����O�����V��u�M�<��/�2�� 5p�}<ƣj�,��*��U��1�/jm�#T	ɒU��,R%D:E���a8l�2��*��4j�>j���o͏�]�:���CV�iC��{����B��`�1x���E�������nU�ž:�<��s�E�Toèj_�CEm���Z?��i�C!˪@�����ħj��ʛ�r���{�����M`g%<�_�x��osR�.����A
J�\*��i���o�~M(��,[!�GXf����,�ɉV@�Ы`��b���wఛR�v�{�f��s{�y0z7�B5*A�V|~��n���aw���S�-�Z����ۣv�gt&�BO�����-�U��{��'t@T�:�#��,$cYolgV����=ޯ�}����[�#�ð�շ�C5@����#V�7�1����Br��J�n-��I�D�l�E�t_Ԏ���͌�H�+yn��f��Q�����O|�T	ﬔv{i��@�[=�������m�}�˴w�e�usܜ�o�eJ?�K/n�0��'�̀�V�/�������N~�AY��P4x��:bI,`���G�߼�\_-n����lV����W�"^w���ۛ�n߯��gI�F�!�T߲z� �?*�Q\;��2���bI��V�]�*,巠%�խ���3[��)�yT�mw޷�}�Be5���VK������E��om�}�̽ۚ �%���5�[����z�;��XT�˺�|��8b�H��5�v��Нȵ,���OW��������V�U��� �^X�VB�W���^yB�mh�[t�q�7ۥ�F~j¥|i#�ز�$	�T6@�ܺ�#Gua��}���Q۳n�6�l�]If�����}/��z����ǎ=�Aju���ޞoj�g/N`j���ת�5����ߨ7�rz�b�iD�O�N�I��z{@5�Q�����w�(��t����������o�K%�oR���?������)K�����_di��ͫMbIGA��Ol�^��w������������➿���W�W�/_�
f      c   )   x�33�4��20 "N0	b`1��S�*bap��qqq h^�     