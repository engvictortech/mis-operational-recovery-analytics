USE MIS_EXSEN;
GO

/*
====================================================
PROJETO MIS EXSEN
TABELAS DIMENSÃO
====================================================

Objetivo:
Criar as dimensões do modelo dimensional
utilizado na solução de MIS.

Modelo:
STAR SCHEMA
====================================================
*/


-- ================================================
-- LIMPEZA DAS DIMENSÕES
-- ================================================

DROP TABLE IF EXISTS dim_operador;
DROP TABLE IF EXISTS dim_equipe;
DROP TABLE IF EXISTS dim_produto;
DROP TABLE IF EXISTS dim_carteira;
DROP TABLE IF EXISTS dim_canal;
DROP TABLE IF EXISTS dim_cliente;
DROP TABLE IF EXISTS dim_data;

GO


-- ================================================
-- 1. DIMENSÃO DATA
-- ================================================

CREATE TABLE dim_data (
    data DATE PRIMARY KEY,
    ano INT,
    mes_numero INT,
    mes_nome VARCHAR(20),
    trimestre VARCHAR(5),
    semana_ano INT,
    dia INT,
    dia_semana_numero INT,
    dia_semana_nome VARCHAR(20),
    fim_de_semana BIT,
    inicio_mes BIT,
    fim_mes BIT
);


-- ================================================
-- 2. DIMENSÃO EQUIPE
-- ================================================

CREATE TABLE dim_equipe (
    equipe_id INT PRIMARY KEY,
    nome_equipe VARCHAR(100),
    operacao VARCHAR(50),
    turno VARCHAR(20)
);


-- ================================================
-- 3. DIMENSÃO OPERADOR
-- ================================================

CREATE TABLE dim_operador (
    operador_id INT PRIMARY KEY,
    nome_operador VARCHAR(100),
    equipe_id INT,
    cargo VARCHAR(50),
    data_admissao DATE,
    status VARCHAR(30),
    turno VARCHAR(20)
);


-- ================================================
-- 4. DIMENSÃO PRODUTO
-- ================================================

CREATE TABLE dim_produto (
    produto_id INT PRIMARY KEY,
    nome_produto VARCHAR(100),
    categoria VARCHAR(50)
);


-- ================================================
-- 5. DIMENSÃO CARTEIRA
-- ================================================

CREATE TABLE dim_carteira (
    carteira_id INT PRIMARY KEY,
    nome_carteira VARCHAR(100),
    faixa_atraso VARCHAR(50),
    dias_atraso_min INT,
    dias_atraso_max INT
);


-- ================================================
-- 6. DIMENSÃO CANAL
-- ================================================

CREATE TABLE dim_canal (
    canal_id INT PRIMARY KEY,
    nome_canal VARCHAR(50),
    tipo_canal VARCHAR(50)
);


-- ================================================
-- 7. DIMENSÃO CLIENTE
-- ================================================

CREATE TABLE dim_cliente (
    cliente_id INT PRIMARY KEY,
    nome_cliente VARCHAR(100),
    cpf_ficticio VARCHAR(30),
    cidade VARCHAR(100),
    estado CHAR(2),
    idade INT,
    segmento VARCHAR(50),
    data_cadastro DATE,
    status VARCHAR(30)
);

GO


-- ================================================
-- VALIDAÇÃO
-- ================================================

SELECT
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE 'dim_%'
ORDER BY TABLE_NAME;