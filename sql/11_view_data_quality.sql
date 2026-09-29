USE MIS_EXSEN;
GO

/*
====================================================
PROJETO MIS EXSEN
VIEW - DATA QUALITY
====================================================

Objetivo:
Disponibilizar os resultados das principais regras
de qualidade de dados para consumo no Power BI.
====================================================
*/


CREATE OR ALTER VIEW vw_data_quality
AS


-- 1. DUPLICIDADE DE ACIONAMENTOS
SELECT
    1 AS id_validacao,
    'Duplicidade' AS categoria,
    'IDs duplicados em acionamentos' AS validacao,
    COUNT(*) AS registros_com_problema,
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END AS status
FROM (
    SELECT acionamento_id
    FROM stg_fato_acionamentos
    GROUP BY acionamento_id
    HAVING COUNT(*) > 1
) x


UNION ALL


-- 2. DUPLICIDADE DE PROMESSAS
SELECT
    2,
    'Duplicidade',
    'IDs duplicados em promessas',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM (
    SELECT promessa_id
    FROM stg_fato_promessas
    GROUP BY promessa_id
    HAVING COUNT(*) > 1
) x


UNION ALL


-- 3. DUPLICIDADE DE PAGAMENTOS
SELECT
    3,
    'Duplicidade',
    'IDs duplicados em pagamentos',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM (
    SELECT pagamento_id
    FROM stg_fato_pagamentos
    GROUP BY pagamento_id
    HAVING COUNT(*) > 1
) x


UNION ALL


-- 4. CHAVES NULAS EM ACIONAMENTOS
SELECT
    4,
    'Campos obrigatórios',
    'Chaves nulas em acionamentos',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_acionamentos
WHERE operador_id IS NULL
   OR cliente_id IS NULL
   OR produto_id IS NULL
   OR carteira_id IS NULL
   OR canal_id IS NULL


UNION ALL


-- 5. CHAVES NULAS EM PROMESSAS
SELECT
    5,
    'Campos obrigatórios',
    'Chaves nulas em promessas',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_promessas
WHERE operador_id IS NULL
   OR cliente_id IS NULL
   OR produto_id IS NULL
   OR carteira_id IS NULL
   OR canal_id IS NULL


UNION ALL


-- 6. CHAVES NULAS EM PAGAMENTOS
SELECT
    6,
    'Campos obrigatórios',
    'Chaves nulas em pagamentos',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_pagamentos
WHERE operador_id IS NULL
   OR cliente_id IS NULL
   OR produto_id IS NULL
   OR carteira_id IS NULL
   OR canal_id IS NULL
   OR promessa_id IS NULL


UNION ALL


-- 7. OPERADORES INEXISTENTES
SELECT
    7,
    'Integridade referencial',
    'Operadores inexistentes em acionamentos',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_acionamentos f
LEFT JOIN dim_operador o
    ON f.operador_id = o.operador_id
WHERE o.operador_id IS NULL


UNION ALL


-- 8. CLIENTES INEXISTENTES
SELECT
    8,
    'Integridade referencial',
    'Clientes inexistentes em acionamentos',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_acionamentos f
LEFT JOIN dim_cliente c
    ON f.cliente_id = c.cliente_id
WHERE c.cliente_id IS NULL


UNION ALL


-- 9. PAGAMENTOS SEM PROMESSA
SELECT
    9,
    'Integridade referencial',
    'Pagamentos sem promessa correspondente',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_pagamentos p
LEFT JOIN fato_promessas pr
    ON p.promessa_id = pr.promessa_id
WHERE pr.promessa_id IS NULL


UNION ALL


-- 10. PROMESSAS COM VALOR INVÁLIDO
SELECT
    10,
    'Regra financeira',
    'Promessas com valor menor ou igual a zero',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_promessas
WHERE valor_promessa <= 0


UNION ALL


-- 11. PAGAMENTOS COM VALOR INVÁLIDO
SELECT
    11,
    'Regra financeira',
    'Pagamentos pagos com valor menor ou igual a zero',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_pagamentos
WHERE status_pagamento = 'Pago'
  AND valor_pago <= 0


UNION ALL


-- 12. RESULTADOS DE ACIONAMENTO INVÁLIDOS
SELECT
    12,
    'Domínio',
    'Resultados de acionamento fora do domínio',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_acionamentos
WHERE resultado NOT IN (
    'Contato efetivo',
    'Sem contato',
    'Número inválido',
    'Recado com terceiro',
    'Cliente indisponível'
)


UNION ALL


-- 13. STATUS DE PROMESSA INVÁLIDO
SELECT
    13,
    'Domínio',
    'Status de promessa fora do domínio',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_promessas
WHERE status_promessa NOT IN (
    'Paga',
    'Pendente',
    'Quebrada'
)


UNION ALL


-- 14. STATUS DE PAGAMENTO INVÁLIDO
SELECT
    14,
    'Domínio',
    'Status de pagamento fora do domínio',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_pagamentos
WHERE status_pagamento NOT IN (
    'Pago',
    'Pendente'
)


UNION ALL


-- 15. VENCIMENTO ANTERIOR À PROMESSA
SELECT
    15,
    'Consistência temporal',
    'Vencimento anterior à data da promessa',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_promessas
WHERE data_vencimento_promessa < data_promessa


UNION ALL


-- 16. PAGAMENTO PAGO SEM DATA
SELECT
    16,
    'Consistência temporal',
    'Pagamento com status Pago e data nula',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_pagamentos
WHERE status_pagamento = 'Pago'
  AND data_pagamento IS NULL


UNION ALL


-- 17. PAGAMENTO ANTERIOR À PROMESSA
SELECT
    17,
    'Consistência temporal',
    'Pagamento anterior à data da promessa',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_pagamentos p
INNER JOIN fato_promessas pr
    ON p.promessa_id = pr.promessa_id
WHERE p.data_pagamento IS NOT NULL
  AND p.data_pagamento < pr.data_promessa


UNION ALL


-- 18. DATA DE ACIONAMENTO FORA DO CALENDÁRIO
SELECT
    18,
    'Dimensão calendário',
    'Datas de acionamento ausentes na dim_data',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_acionamentos f
LEFT JOIN dim_data d
    ON f.data_acionamento = d.data
WHERE d.data IS NULL


UNION ALL


-- 19. DATA DE PROMESSA FORA DO CALENDÁRIO
SELECT
    19,
    'Dimensão calendário',
    'Datas de promessa ausentes na dim_data',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_promessas p
LEFT JOIN dim_data d
    ON p.data_promessa = d.data
WHERE d.data IS NULL


UNION ALL


-- 20. DATA DE PAGAMENTO FORA DO CALENDÁRIO
SELECT
    20,
    'Dimensão calendário',
    'Datas de pagamento ausentes na dim_data',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'APROVADO'
        ELSE 'REVISAR'
    END
FROM fato_pagamentos p
LEFT JOIN dim_data d
    ON p.data_pagamento = d.data
WHERE p.data_pagamento IS NOT NULL
  AND d.data IS NULL


UNION ALL


-- 21. DIVERGÊNCIA DE VOLUME - ACIONAMENTOS
SELECT
    21,
    'ETL',
    'Diferença staging x fato_acionamentos',
    ABS(
        (SELECT COUNT(*) FROM stg_fato_acionamentos)
        -
        (SELECT COUNT(*) FROM fato_acionamentos)
    ),
    CASE
        WHEN
            (SELECT COUNT(*) FROM stg_fato_acionamentos)
            =
            (SELECT COUNT(*) FROM fato_acionamentos)
        THEN 'APROVADO'
        ELSE 'REVISAR'
    END


UNION ALL


-- 22. DIVERGÊNCIA DE VOLUME - PROMESSAS
SELECT
    22,
    'ETL',
    'Diferença staging x fato_promessas',
    ABS(
        (SELECT COUNT(*) FROM stg_fato_promessas)
        -
        (SELECT COUNT(*) FROM fato_promessas)
    ),
    CASE
        WHEN
            (SELECT COUNT(*) FROM stg_fato_promessas)
            =
            (SELECT COUNT(*) FROM fato_promessas)
        THEN 'APROVADO'
        ELSE 'REVISAR'
    END


UNION ALL


-- 23. DIVERGÊNCIA DE VOLUME - PAGAMENTOS
SELECT
    23,
    'ETL',
    'Diferença staging x fato_pagamentos',
    ABS(
        (SELECT COUNT(*) FROM stg_fato_pagamentos)
        -
        (SELECT COUNT(*) FROM fato_pagamentos)
    ),
    CASE
        WHEN
            (SELECT COUNT(*) FROM stg_fato_pagamentos)
            =
            (SELECT COUNT(*) FROM fato_pagamentos)
        THEN 'APROVADO'
        ELSE 'REVISAR'
    END;

GO


-- ================================================
-- TESTE
-- ================================================

SELECT *
FROM vw_data_quality
ORDER BY id_validacao;