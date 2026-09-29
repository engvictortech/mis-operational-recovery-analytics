USE MIS_EXSEN;
GO

/*
====================================================
PROJETO MIS EXSEN
TABELAS FATO
====================================================

Objetivo:
Criar as tabelas fato do modelo dimensional.

Modelo:
STAR SCHEMA

Fatos:
- Acionamentos
- Promessas
- Pagamentos
====================================================
*/


-- ================================================
-- LIMPEZA DAS TABELAS FATO
-- ================================================

DROP TABLE IF EXISTS fato_pagamentos;
DROP TABLE IF EXISTS fato_promessas;
DROP TABLE IF EXISTS fato_acionamentos;

GO


-- ================================================
-- 1. FATO ACIONAMENTOS
-- ================================================

CREATE TABLE fato_acionamentos (
    acionamento_id INT PRIMARY KEY,
    data_acionamento DATE NOT NULL,
    operador_id INT NOT NULL,
    cliente_id INT NOT NULL,
    produto_id INT NOT NULL,
    carteira_id INT NOT NULL,
    canal_id INT NOT NULL,
    quantidade_tentativas INT,
    resultado VARCHAR(50),
    contato_efetivo INT,
    promessa_pagamento INT,
    valor_promessa DECIMAL(18,2)
);


-- ================================================
-- 2. FATO PROMESSAS
-- ================================================

CREATE TABLE fato_promessas (
    promessa_id INT PRIMARY KEY,
    data_promessa DATE NOT NULL,
    data_vencimento_promessa DATE,
    operador_id INT NOT NULL,
    cliente_id INT NOT NULL,
    produto_id INT NOT NULL,
    carteira_id INT NOT NULL,
    canal_id INT NOT NULL,
    valor_promessa DECIMAL(18,2),
    status_promessa VARCHAR(30)
);


-- ================================================
-- 3. FATO PAGAMENTOS
-- ================================================

CREATE TABLE fato_pagamentos (
    pagamento_id INT PRIMARY KEY,
    data_pagamento DATE,
    operador_id INT NOT NULL,
    cliente_id INT NOT NULL,
    produto_id INT NOT NULL,
    carteira_id INT NOT NULL,
    canal_id INT NOT NULL,
    promessa_id INT NOT NULL,
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
WHERE TABLE_NAME LIKE 'fato_%'
ORDER BY TABLE_NAME;