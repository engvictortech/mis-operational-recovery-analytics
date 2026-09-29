USE MIS_EXSEN;
GO

/*
====================================================
PROJETO MIS EXSEN
CAMADA STAGING
====================================================

Objetivo:
Criar as tabelas de staging utilizadas para receber
os dados processados antes da carga no modelo
dimensional.

As tabelas podem ser recriadas durante testes.
====================================================
*/


-- ================================================
-- LIMPEZA DAS TABELAS DE STAGING
-- ================================================

DROP TABLE IF EXISTS stg_fato_pagamentos;
DROP TABLE IF EXISTS stg_fato_promessas;
DROP TABLE IF EXISTS stg_fato_acionamentos;

DROP TABLE IF EXISTS stg_dim_cliente;
DROP TABLE IF EXISTS stg_dim_data;
DROP TABLE IF EXISTS stg_dim_canal;
DROP TABLE IF EXISTS stg_dim_carteira;
DROP TABLE IF EXISTS stg_dim_produto;
DROP TABLE IF EXISTS stg_dim_operador;
DROP TABLE IF EXISTS stg_dim_equipe;

GO


-- ================================================
-- 1. STAGING - EQUIPE
-- ================================================

CREATE TABLE stg_dim_equipe (
    equipe_id INT,
    nome_equipe VARCHAR(100),
    operacao VARCHAR(50),
    turno VARCHAR(20)
);


-- ================================================
-- 2. STAGING - OPERADOR
-- ================================================

CREATE TABLE stg_dim_operador (
    operador_id INT,
    nome_operador VARCHAR(100),
    equipe_id INT,
    cargo VARCHAR(50),
    data_admissao DATE,
    status VARCHAR(30),
    turno VARCHAR(20)
);


-- ================================================
-- 3. STAGING - PRODUTO
-- ================================================

CREATE TABLE stg_dim_produto (
    produto_id INT,
    nome_produto VARCHAR(100),
    categoria VARCHAR(50)
);


-- ================================================
-- 4. STAGING - CARTEIRA
-- ================================================

CREATE TABLE stg_dim_carteira (
    carteira_id INT,
    nome_carteira VARCHAR(100),
    faixa_atraso VARCHAR(50),
    dias_atraso_min INT,
    dias_atraso_max INT
);


-- ================================================
-- 5. STAGING - CANAL
-- ================================================

CREATE TABLE stg_dim_canal (
    canal_id INT,
    nome_canal VARCHAR(50),
    tipo_canal VARCHAR(50)
);


-- ================================================
-- 6. STAGING - DATA
-- ================================================

CREATE TABLE stg_dim_data (
    data DATE,
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
-- 7. STAGING - CLIENTE
-- ================================================

CREATE TABLE stg_dim_cliente (
    cliente_id INT,
    nome_cliente VARCHAR(100),
    cpf_ficticio VARCHAR(30),
    cidade VARCHAR(100),
    estado CHAR(2),
    idade INT,
    segmento VARCHAR(50),
    data_cadastro DATE,
    status VARCHAR(30)
);


-- ================================================
-- 8. STAGING - ACIONAMENTOS
-- ================================================

CREATE TABLE stg_fato_acionamentos (
    acionamento_id INT,
    data_acionamento DATE,
    operador_id INT,
    cliente_id INT,
    produto_id INT,
    carteira_id INT,
    canal_id INT,
    quantidade_tentativas INT,
    resultado VARCHAR(50),
    contato_efetivo INT,
    promessa_pagamento INT,
    valor_promessa DECIMAL(18,2)
);


-- ================================================
-- 9. STAGING - PROMESSAS
-- ================================================

CREATE TABLE stg_fato_promessas (
    promessa_id INT,
    data_promessa DATE,
    data_vencimento_promessa DATE,
    operador_id INT,
    cliente_id INT,
    produto_id INT,
    carteira_id INT,
    canal_id INT,
    valor_promessa DECIMAL(18,2),
    status_promessa VARCHAR(30)
);


-- ================================================
-- 10. STAGING - PAGAMENTOS
-- ================================================

CREATE TABLE stg_fato_pagamentos (
    pagamento_id INT,
    data_pagamento DATE,
    operador_id INT,
    cliente_id INT,
    produto_id INT,
    carteira_id INT,
    canal_id INT,
    promessa_id INT,
    valor_pago DECIMAL(18,2),
    status_pagamento VARCHAR(30)
);

GO


-- ================================================
-- VALIDAÇÃO
-- ================================================

SELECT
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE 'stg_%'
ORDER BY TABLE_NAME;