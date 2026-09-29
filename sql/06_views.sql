/*
====================================================
PROJETO MIS EXSEN
VIEWS ANALÍTICAS
====================================================

Objetivo:
Criar views para facilitar consultas de MIS,
relatórios e integração com Power BI.
====================================================
*/


-- ================================================
-- 1. VIEW DE ACIONAMENTOS
-- ================================================

CREATE VIEW vw_acionamentos_operacional AS

SELECT
    f.acionamento_id,
    f.data_acionamento,
    f.operador_id,
    o.nome_operador,
    o.equipe_id,
    e.nome_equipe,
    e.operacao,
    f.cliente_id,
    c.segmento,
    c.cidade,
    f.produto_id,
    p.nome_produto,
    f.carteira_id,
    ca.faixa_atraso,
    f.canal_id,
    cn.nome_canal,
    cn.tipo_canal,
    f.quantidade_tentativas,
    f.resultado,
    f.contato_efetivo,
    f.promessa_pagamento,
    f.valor_promessa

FROM fato_acionamentos f

INNER JOIN dim_operador o
    ON f.operador_id = o.operador_id

INNER JOIN dim_equipe e
    ON o.equipe_id = e.equipe_id

INNER JOIN dim_cliente c
    ON f.cliente_id = c.cliente_id

INNER JOIN dim_produto p
    ON f.produto_id = p.produto_id

INNER JOIN dim_carteira ca
    ON f.carteira_id = ca.carteira_id

INNER JOIN dim_canal cn
    ON f.canal_id = cn.canal_id;


-- ================================================
-- 2. VIEW DE PROMESSAS
-- ================================================

CREATE VIEW vw_promessas_operacional AS

SELECT
    f.promessa_id,
    f.data_promessa,
    f.data_vencimento_promessa,
    f.operador_id,
    o.nome_operador,
    o.equipe_id,
    e.nome_equipe,
    e.operacao,
    f.cliente_id,
    c.segmento,
    f.produto_id,
    p.nome_produto,
    f.carteira_id,
    ca.faixa_atraso,
    f.canal_id,
    cn.nome_canal,
    f.valor_promessa,
    f.status_promessa

FROM fato_promessas f

INNER JOIN dim_operador o
    ON f.operador_id = o.operador_id

INNER JOIN dim_equipe e
    ON o.equipe_id = e.equipe_id

INNER JOIN dim_cliente c
    ON f.cliente_id = c.cliente_id

INNER JOIN dim_produto p
    ON f.produto_id = p.produto_id

INNER JOIN dim_carteira ca
    ON f.carteira_id = ca.carteira_id

INNER JOIN dim_canal cn
    ON f.canal_id = cn.canal_id;


-- ================================================
-- 3. VIEW DE PAGAMENTOS
-- ================================================

CREATE VIEW vw_pagamentos_operacional AS

SELECT
    f.pagamento_id,
    f.data_pagamento,
    f.operador_id,
    o.nome_operador,
    o.equipe_id,
    e.nome_equipe,
    e.operacao,
    f.cliente_id,
    c.segmento,
    f.produto_id,
    p.nome_produto,
    f.carteira_id,
    ca.faixa_atraso,
    f.canal_id,
    cn.nome_canal,
    f.promessa_id,
    f.valor_pago,
    f.status_pagamento

FROM fato_pagamentos f

INNER JOIN dim_operador o
    ON f.operador_id = o.operador_id

INNER JOIN dim_equipe e
    ON o.equipe_id = e.equipe_id

INNER JOIN dim_cliente c
    ON f.cliente_id = c.cliente_id

INNER JOIN dim_produto p
    ON f.produto_id = p.produto_id

INNER JOIN dim_carteira ca
    ON f.carteira_id = ca.carteira_id

INNER JOIN dim_canal cn
    ON f.canal_id = cn.canal_id;


-- ================================================
-- 4. VIEW EXECUTIVA DE PERFORMANCE
-- ================================================

CREATE VIEW vw_performance_operacional AS

SELECT
    e.equipe_id,
    e.nome_equipe,
    e.operacao,
    COUNT(f.acionamento_id) AS total_acionamentos,

    SUM(
        CASE
            WHEN f.contato_efetivo = 1 THEN 1
            ELSE 0
        END
    ) AS contatos_efetivos,

    SUM(
        CASE
            WHEN f.promessa_pagamento = 1 THEN 1
            ELSE 0
        END
    ) AS total_promessas,

    SUM(
        CASE
            WHEN f.contato_efetivo = 1 THEN 1
            ELSE 0
        END
    ) * 1.0
    /
    NULLIF(COUNT(f.acionamento_id), 0)
    AS taxa_contato,

    SUM(
        CASE
            WHEN f.promessa_pagamento = 1 THEN 1
            ELSE 0
        END
    ) * 1.0
    /
    NULLIF(
        SUM(
            CASE
                WHEN f.contato_efetivo = 1 THEN 1
                ELSE 0
            END
        ), 0
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
    e.operacao;