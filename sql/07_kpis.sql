/*
====================================================
PROJETO MIS EXSEN
KPIs OPERACIONAIS
====================================================

Objetivo:
Criar consultas SQL para os principais indicadores
de uma operação de MIS / Cobrança.

KPIs:
- Total de acionamentos
- Contatos efetivos
- Taxa de contato
- Total de promessas
- Taxa de conversão
- Valor prometido
- Valor recuperado
- Recovery Rate
====================================================
*/


-- ================================================
-- 1. TOTAL DE ACIONAMENTOS
-- ================================================

SELECT
    COUNT(*) AS total_acionamentos
FROM fato_acionamentos;


-- ================================================
-- 2. CONTATOS EFETIVOS
-- ================================================

SELECT
    SUM(
        CASE
            WHEN contato_efetivo = 1 THEN 1
            ELSE 0
        END
    ) AS contatos_efetivos
FROM fato_acionamentos;


-- ================================================
-- 3. TAXA DE CONTATO
-- ================================================

SELECT
    CAST(
        SUM(
            CASE
                WHEN contato_efetivo = 1 THEN 1
                ELSE 0
            END
        ) AS DECIMAL(18,4)
    )
    /
    NULLIF(COUNT(*), 0) AS taxa_contato
FROM fato_acionamentos;


-- ================================================
-- 4. TOTAL DE PROMESSAS
-- ================================================

SELECT
    COUNT(*) AS total_promessas
FROM fato_promessas;


-- ================================================
-- 5. TAXA DE CONVERSÃO
-- ================================================

SELECT
    CAST(
        SUM(
            CASE
                WHEN promessa_pagamento = 1 THEN 1
                ELSE 0
            END
        ) AS DECIMAL(18,4)
    )
    /
    NULLIF(
        SUM(
            CASE
                WHEN contato_efetivo = 1 THEN 1
                ELSE 0
            END
        ),
        0
    ) AS taxa_conversao
FROM fato_acionamentos;


-- ================================================
-- 6. VALOR TOTAL PROMETIDO
-- ================================================

SELECT
    SUM(valor_promessa) AS valor_total_prometido
FROM fato_promessas;


-- ================================================
-- 7. VALOR TOTAL RECUPERADO
-- ================================================

SELECT
    SUM(valor_pago) AS valor_total_recuperado
FROM fato_pagamentos
WHERE status_pagamento = 'Pago';


-- ================================================
-- 8. RECOVERY RATE
-- ================================================

SELECT
    CAST(
        SUM(
            CASE
                WHEN status_pagamento = 'Pago'
                THEN valor_pago
                ELSE 0
            END
        ) AS DECIMAL(18,2)
    )
    /
    NULLIF(
        SUM(valor_promessa),
        0
    ) AS recovery_rate
FROM fato_pagamentos p

INNER JOIN fato_promessas pr
    ON p.promessa_id = pr.promessa_id;


-- ================================================
-- 9. PERFORMANCE POR EQUIPE
-- ================================================

SELECT
    e.equipe_id,
    e.nome_equipe,
    e.operacao,

    COUNT(f.acionamento_id) AS acionamentos,

    SUM(
        CASE
            WHEN f.contato_efetivo = 1 THEN 1
            ELSE 0
        END
    ) AS contatos,

    SUM(
        CASE
            WHEN f.promessa_pagamento = 1 THEN 1
            ELSE 0
        END
    ) AS promessas,

    CAST(
        SUM(
            CASE
                WHEN f.contato_efetivo = 1 THEN 1
                ELSE 0
            END
        ) AS DECIMAL(18,4)
    )
    /
    NULLIF(COUNT(f.acionamento_id), 0)
    AS taxa_contato,

    CAST(
        SUM(
            CASE
                WHEN f.promessa_pagamento = 1 THEN 1
                ELSE 0
            END
        ) AS DECIMAL(18,4)
    )
    /
    NULLIF(
        SUM(
            CASE
                WHEN f.contato_efetivo = 1 THEN 1
                ELSE 0
            END
        ),
        0
    )
    AS taxa_conversao

FROM fato_acionamentos f

INNER JOIN dim_operador o
    ON f.operador_id = o.operador_id

INNER JOIN dim_equipe e
    ON o.equipe_id = e.equipe_id

GROUP BY
    e.equipe_id,
    e.nome_equipe,
    e.operacao

ORDER BY
    taxa_conversao DESC;


-- ================================================
-- 10. PERFORMANCE POR OPERADOR
-- ================================================

SELECT
    o.operador_id,
    o.nome_operador,
    e.nome_equipe,

    COUNT(f.acionamento_id) AS acionamentos,

    SUM(
        CASE
            WHEN f.contato_efetivo = 1 THEN 1
            ELSE 0
        END
    ) AS contatos,

    SUM(
        CASE
            WHEN f.promessa_pagamento = 1 THEN 1
            ELSE 0
        END
    ) AS promessas,

    CAST(
        SUM(
            CASE
                WHEN f.contato_efetivo = 1 THEN 1
                ELSE 0
            END
        ) AS DECIMAL(18,4)
    )
    /
    NULLIF(COUNT(f.acionamento_id), 0)
    AS taxa_contato,

    CAST(
        SUM(
            CASE
                WHEN f.promessa_pagamento = 1 THEN 1
                ELSE 0
            END
        ) AS DECIMAL(18,4)
    )
    /
    NULLIF(
        SUM(
            CASE
                WHEN f.contato_efetivo = 1 THEN 1
                ELSE 0
            END
        ),
        0
    )
    AS taxa_conversao

FROM fato_acionamentos f

INNER JOIN dim_operador o
    ON f.operador_id = o.operador_id

INNER JOIN dim_equipe e
    ON o.equipe_id = e.equipe_id

GROUP BY
    o.operador_id,
    o.nome_operador,
    e.nome_equipe

ORDER BY
    taxa_conversao DESC;