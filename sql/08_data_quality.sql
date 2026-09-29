USE MIS_EXSEN;
GO

/*
====================================================
PROJETO MIS EXSEN
DATA QUALITY & DATA VALIDATION
====================================================

Objetivo:
Executar uma auditoria de qualidade sobre a camada
staging e o modelo dimensional.

Validações:
- Duplicidades
- Valores nulos
- Integridade referencial
- Valores financeiros inválidos
- Domínios de status
- Consistência de datas
- Cobertura da dimensão calendário
- Conferência de volumes do ETL
====================================================
*/

SET NOCOUNT ON;


-- ================================================
-- TABELA TEMPORÁRIA DE RESULTADOS
-- ================================================

DECLARE @qualidade TABLE (
    id_validacao INT,
    categoria VARCHAR(50),
    validacao VARCHAR(150),
    registros_com_problema BIGINT,
    status VARCHAR(20)
);


-- ================================================
-- 1. DUPLICIDADE - ACIONAMENTOS
-- ================================================

INSERT INTO @qualidade
SELECT
    1,
    'Duplicidade',
    'IDs duplicados em stg_fato_acionamentos',
    COUNT(*),
    NULL
FROM (
    SELECT acionamento_id
    FROM stg_fato_acionamentos
    GROUP BY acionamento_id
    HAVING COUNT(*) > 1
) x;


-- ================================================
-- 2. DUPLICIDADE - PROMESSAS
-- ================================================

INSERT INTO @qualidade
SELECT
    2,
    'Duplicidade',
    'IDs duplicados em stg_fato_promessas',
    COUNT(*),
    NULL
FROM (
    SELECT promessa_id
    FROM stg_fato_promessas
    GROUP BY promessa_id
    HAVING COUNT(*) > 1
) x;


-- ================================================
-- 3. DUPLICIDADE - PAGAMENTOS
-- ================================================

INSERT INTO @qualidade
SELECT
    3,
    'Duplicidade',
    'IDs duplicados em stg_fato_pagamentos',
    COUNT(*),
    NULL
FROM (
    SELECT pagamento_id
    FROM stg_fato_pagamentos
    GROUP BY pagamento_id
    HAVING COUNT(*) > 1
) x;


-- ================================================
-- 4. NULOS - ACIONAMENTOS
-- ================================================

INSERT INTO @qualidade
SELECT
    4,
    'Campos obrigatórios',
    'Chaves nulas em fato_acionamentos',
    COUNT(*),
    NULL
FROM fato_acionamentos
WHERE operador_id IS NULL
   OR cliente_id IS NULL
   OR produto_id IS NULL
   OR carteira_id IS NULL
   OR canal_id IS NULL;


-- ================================================
-- 5. NULOS - PROMESSAS
-- ================================================

INSERT INTO @qualidade
SELECT
    5,
    'Campos obrigatórios',
    'Chaves nulas em fato_promessas',
    COUNT(*),
    NULL
FROM fato_promessas
WHERE operador_id IS NULL
   OR cliente_id IS NULL
   OR produto_id IS NULL
   OR carteira_id IS NULL
   OR canal_id IS NULL;


-- ================================================
-- 6. NULOS - PAGAMENTOS
-- ================================================

INSERT INTO @qualidade
SELECT
    6,
    'Campos obrigatórios',
    'Chaves nulas em fato_pagamentos',
    COUNT(*),
    NULL
FROM fato_pagamentos
WHERE operador_id IS NULL
   OR cliente_id IS NULL
   OR produto_id IS NULL
   OR carteira_id IS NULL
   OR canal_id IS NULL
   OR promessa_id IS NULL;


-- ================================================
-- 7. INTEGRIDADE - OPERADORES
-- ================================================

INSERT INTO @qualidade
SELECT
    7,
    'Integridade referencial',
    'Operadores inexistentes em acionamentos',
    COUNT(*),
    NULL
FROM fato_acionamentos f

LEFT JOIN dim_operador o
    ON f.operador_id = o.operador_id

WHERE o.operador_id IS NULL;


-- ================================================
-- 8. INTEGRIDADE - CLIENTES
-- ================================================

INSERT INTO @qualidade
SELECT
    8,
    'Integridade referencial',
    'Clientes inexistentes em acionamentos',
    COUNT(*),
    NULL
FROM fato_acionamentos f

LEFT JOIN dim_cliente c
    ON f.cliente_id = c.cliente_id

WHERE c.cliente_id IS NULL;


-- ================================================
-- 9. PAGAMENTOS SEM PROMESSA
-- ================================================

INSERT INTO @qualidade
SELECT
    9,
    'Integridade referencial',
    'Pagamentos sem promessa correspondente',
    COUNT(*),
    NULL
FROM fato_pagamentos p

LEFT JOIN fato_promessas pr
    ON p.promessa_id = pr.promessa_id

WHERE pr.promessa_id IS NULL;


-- ================================================
-- 10. VALOR DE PROMESSA INVÁLIDO
-- ================================================

INSERT INTO @qualidade
SELECT
    10,
    'Regra financeira',
    'Promessas com valor menor ou igual a zero',
    COUNT(*),
    NULL
FROM fato_promessas
WHERE valor_promessa <= 0;


-- ================================================
-- 11. PAGAMENTO PAGO COM VALOR INVÁLIDO
-- ================================================

INSERT INTO @qualidade
SELECT
    11,
    'Regra financeira',
    'Pagamentos pagos com valor menor ou igual a zero',
    COUNT(*),
    NULL
FROM fato_pagamentos
WHERE status_pagamento = 'Pago'
  AND valor_pago <= 0;


-- ================================================
-- 12. RESULTADO DE ACIONAMENTO INVÁLIDO
-- ================================================

INSERT INTO @qualidade
SELECT
    12,
    'Domínio',
    'Resultados de acionamento fora do domínio',
    COUNT(*),
    NULL
FROM fato_acionamentos
WHERE resultado NOT IN (
    'Contato efetivo',
    'Sem contato',
    'Número inválido',
    'Recado com terceiro',
    'Cliente indisponível'
);


-- ================================================
-- 13. STATUS DE PROMESSA INVÁLIDO
-- ================================================

INSERT INTO @qualidade
SELECT
    13,
    'Domínio',
    'Status de promessa fora do domínio',
    COUNT(*),
    NULL
FROM fato_promessas
WHERE status_promessa NOT IN (
    'Paga',
    'Pendente',
    'Quebrada'
);


-- ================================================
-- 14. STATUS DE PAGAMENTO INVÁLIDO
-- ================================================

INSERT INTO @qualidade
SELECT
    14,
    'Domínio',
    'Status de pagamento fora do domínio',
    COUNT(*),
    NULL
FROM fato_pagamentos
WHERE status_pagamento NOT IN (
    'Pago',
    'Pendente'
);


-- ================================================
-- 15. VENCIMENTO ANTERIOR À PROMESSA
-- ================================================

INSERT INTO @qualidade
SELECT
    15,
    'Consistência temporal',
    'Promessa com vencimento anterior à criação',
    COUNT(*),
    NULL
FROM fato_promessas
WHERE data_vencimento_promessa < data_promessa;


-- ================================================
-- 16. PAGAMENTO PAGO SEM DATA
-- ================================================

INSERT INTO @qualidade
SELECT
    16,
    'Consistência temporal',
    'Pagamento com status Pago e data nula',
    COUNT(*),
    NULL
FROM fato_pagamentos
WHERE status_pagamento = 'Pago'
  AND data_pagamento IS NULL;


-- ================================================
-- 17. PAGAMENTO ANTERIOR À PROMESSA
-- ================================================

INSERT INTO @qualidade
SELECT
    17,
    'Consistência temporal',
    'Pagamento anterior à data da promessa',
    COUNT(*),
    NULL
FROM fato_pagamentos p

INNER JOIN fato_promessas pr
    ON p.promessa_id = pr.promessa_id

WHERE p.data_pagamento IS NOT NULL
  AND p.data_pagamento < pr.data_promessa;


-- ================================================
-- 18. DATA DE ACIONAMENTO FORA DO CALENDÁRIO
-- ================================================

INSERT INTO @qualidade
SELECT
    18,
    'Dimensão calendário',
    'Datas de acionamento ausentes na dim_data',
    COUNT(*),
    NULL
FROM fato_acionamentos f

LEFT JOIN dim_data d
    ON f.data_acionamento = d.data

WHERE d.data IS NULL;


-- ================================================
-- 19. DATA DE PROMESSA FORA DO CALENDÁRIO
-- ================================================

INSERT INTO @qualidade
SELECT
    19,
    'Dimensão calendário',
    'Datas de promessa ausentes na dim_data',
    COUNT(*),
    NULL
FROM fato_promessas p

LEFT JOIN dim_data d
    ON p.data_promessa = d.data

WHERE d.data IS NULL;


-- ================================================
-- 20. DATA DE PAGAMENTO FORA DO CALENDÁRIO
-- ================================================

INSERT INTO @qualidade
SELECT
    20,
    'Dimensão calendário',
    'Datas de pagamento ausentes na dim_data',
    COUNT(*),
    NULL
FROM fato_pagamentos p

LEFT JOIN dim_data d
    ON p.data_pagamento = d.data

WHERE p.data_pagamento IS NOT NULL
  AND d.data IS NULL;


-- ================================================
-- 21. VOLUME ACIONAMENTOS
-- ================================================

INSERT INTO @qualidade
SELECT
    21,
    'ETL',
    'Diferença de volume staging x fato_acionamentos',
    ABS(
        (SELECT COUNT(*) FROM stg_fato_acionamentos)
        -
        (SELECT COUNT(*) FROM fato_acionamentos)
    ),
    NULL;


-- ================================================
-- 22. VOLUME PROMESSAS
-- ================================================

INSERT INTO @qualidade
SELECT
    22,
    'ETL',
    'Diferença de volume staging x fato_promessas',
    ABS(
        (SELECT COUNT(*) FROM stg_fato_promessas)
        -
        (SELECT COUNT(*) FROM fato_promessas)
    ),
    NULL;


-- ================================================
-- 23. VOLUME PAGAMENTOS
-- ================================================

INSERT INTO @qualidade
SELECT
    23,
    'ETL',
    'Diferença de volume staging x fato_pagamentos',
    ABS(
        (SELECT COUNT(*) FROM stg_fato_pagamentos)
        -
        (SELECT COUNT(*) FROM fato_pagamentos)
    ),
    NULL;


-- ================================================
-- CLASSIFICAÇÃO
-- ================================================

UPDATE @qualidade
SET status =
    CASE
        WHEN registros_com_problema = 0
        THEN 'APROVADO'
        ELSE 'REVISAR'
    END;


-- ================================================
-- RESULTADO DETALHADO
-- ================================================

SELECT
    id_validacao,
    categoria,
    validacao,
    registros_com_problema,
    status
FROM @qualidade
ORDER BY id_validacao;


-- ================================================
-- RESUMO DA AUDITORIA
-- ================================================

SELECT
    COUNT(*) AS total_regras,

    SUM(
        CASE
            WHEN registros_com_problema = 0
            THEN 1
            ELSE 0
        END
    ) AS regras_aprovadas,

    SUM(
        CASE
            WHEN registros_com_problema > 0
            THEN 1
            ELSE 0
        END
    ) AS regras_para_revisar,

    CAST(
        SUM(
            CASE
                WHEN registros_com_problema = 0
                THEN 1
                ELSE 0
            END
        ) * 100.0
        /
        COUNT(*)
        AS DECIMAL(5,2)
    ) AS percentual_regras_aprovadas

FROM @qualidade;