USE MIS_EXSEN;
GO

/*
====================================================
PROJETO MIS EXSEN
CARGA DO MODELO DIMENSIONAL
====================================================

Objetivo:
Carregar os dados da camada de staging para
as dimensões e tabelas fato do Data Mart.

Fluxo:
STAGING -> DIMENSÕES -> FATOS

A carga utiliza transação para garantir
consistência em caso de falha.
====================================================
*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

    BEGIN TRANSACTION;


    -- ================================================
    -- 1. LIMPEZA DO MODELO
    -- ================================================

    -- Primeiro as tabelas fato, respeitando as FKs

    DELETE FROM fato_pagamentos;
    DELETE FROM fato_promessas;
    DELETE FROM fato_acionamentos;


    -- Depois as dimensões

    DELETE FROM dim_operador;
    DELETE FROM dim_equipe;
    DELETE FROM dim_produto;
    DELETE FROM dim_carteira;
    DELETE FROM dim_canal;
    DELETE FROM dim_cliente;
    DELETE FROM dim_data;


    -- ================================================
    -- 2. DIMENSÃO DATA
    -- ================================================

    INSERT INTO dim_data (
        data,
        ano,
        mes_numero,
        mes_nome,
        trimestre,
        semana_ano,
        dia,
        dia_semana_numero,
        dia_semana_nome,
        fim_de_semana,
        inicio_mes,
        fim_mes
    )
    SELECT
        data,
        ano,
        mes_numero,
        mes_nome,
        trimestre,
        semana_ano,
        dia,
        dia_semana_numero,
        dia_semana_nome,
        fim_de_semana,
        inicio_mes,
        fim_mes
    FROM stg_dim_data;


    -- ================================================
    -- 3. DIMENSÃO EQUIPE
    -- ================================================

    INSERT INTO dim_equipe (
        equipe_id,
        nome_equipe,
        operacao,
        turno
    )
    SELECT
        equipe_id,
        nome_equipe,
        operacao,
        turno
    FROM stg_dim_equipe;


    -- ================================================
    -- 4. DIMENSÃO OPERADOR
    -- ================================================

    INSERT INTO dim_operador (
        operador_id,
        nome_operador,
        equipe_id,
        cargo,
        data_admissao,
        status,
        turno
    )
    SELECT
        operador_id,
        nome_operador,
        equipe_id,
        cargo,
        data_admissao,
        status,
        turno
    FROM stg_dim_operador;


    -- ================================================
    -- 5. DIMENSÃO PRODUTO
    -- ================================================

    INSERT INTO dim_produto (
        produto_id,
        nome_produto,
        categoria
    )
    SELECT
        produto_id,
        nome_produto,
        categoria
    FROM stg_dim_produto;


    -- ================================================
    -- 6. DIMENSÃO CARTEIRA
    -- ================================================

    INSERT INTO dim_carteira (
        carteira_id,
        nome_carteira,
        faixa_atraso,
        dias_atraso_min,
        dias_atraso_max
    )
    SELECT
        carteira_id,
        nome_carteira,
        faixa_atraso,
        dias_atraso_min,
        dias_atraso_max
    FROM stg_dim_carteira;


    -- ================================================
    -- 7. DIMENSÃO CANAL
    -- ================================================

    INSERT INTO dim_canal (
        canal_id,
        nome_canal,
        tipo_canal
    )
    SELECT
        canal_id,
        nome_canal,
        tipo_canal
    FROM stg_dim_canal;


    -- ================================================
    -- 8. DIMENSÃO CLIENTE
    -- ================================================

    INSERT INTO dim_cliente (
        cliente_id,
        nome_cliente,
        cpf_ficticio,
        cidade,
        estado,
        idade,
        segmento,
        data_cadastro,
        status
    )
    SELECT
        cliente_id,
        nome_cliente,
        cpf_ficticio,
        cidade,
        estado,
        idade,
        segmento,
        data_cadastro,
        status
    FROM stg_dim_cliente;


    -- ================================================
    -- 9. FATO ACIONAMENTOS
    -- ================================================

    INSERT INTO fato_acionamentos (
        acionamento_id,
        data_acionamento,
        operador_id,
        cliente_id,
        produto_id,
        carteira_id,
        canal_id,
        quantidade_tentativas,
        resultado,
        contato_efetivo,
        promessa_pagamento,
        valor_promessa
    )
    SELECT
        acionamento_id,
        data_acionamento,
        operador_id,
        cliente_id,
        produto_id,
        carteira_id,
        canal_id,
        quantidade_tentativas,
        resultado,
        contato_efetivo,
        promessa_pagamento,
        valor_promessa
    FROM stg_fato_acionamentos;


    -- ================================================
    -- 10. FATO PROMESSAS
    -- ================================================

    INSERT INTO fato_promessas (
        promessa_id,
        data_promessa,
        data_vencimento_promessa,
        operador_id,
        cliente_id,
        produto_id,
        carteira_id,
        canal_id,
        valor_promessa,
        status_promessa
    )
    SELECT
        promessa_id,
        data_promessa,
        data_vencimento_promessa,
        operador_id,
        cliente_id,
        produto_id,
        carteira_id,
        canal_id,
        valor_promessa,
        status_promessa
    FROM stg_fato_promessas;


    -- ================================================
    -- 11. FATO PAGAMENTOS
    -- ================================================

    INSERT INTO fato_pagamentos (
        pagamento_id,
        data_pagamento,
        operador_id,
        cliente_id,
        produto_id,
        carteira_id,
        canal_id,
        promessa_id,
        valor_pago,
        status_pagamento
    )
    SELECT
        pagamento_id,
        data_pagamento,
        operador_id,
        cliente_id,
        produto_id,
        carteira_id,
        canal_id,
        promessa_id,
        valor_pago,
        status_pagamento
    FROM stg_fato_pagamentos;


    COMMIT TRANSACTION;

    PRINT 'CARGA DO MODELO CONCLUÍDA COM SUCESSO!';

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'ERRO NA CARGA DO MODELO:';
    PRINT ERROR_MESSAGE();

    THROW;

END CATCH;

GO


-- ================================================
-- 12. VALIDAÇÃO DOS VOLUMES
-- ================================================

SELECT 'dim_data' AS tabela, COUNT(*) AS registros
FROM dim_data

UNION ALL

SELECT 'dim_equipe', COUNT(*)
FROM dim_equipe

UNION ALL

SELECT 'dim_operador', COUNT(*)
FROM dim_operador

UNION ALL

SELECT 'dim_produto', COUNT(*)
FROM dim_produto

UNION ALL

SELECT 'dim_carteira', COUNT(*)
FROM dim_carteira

UNION ALL

SELECT 'dim_canal', COUNT(*)
FROM dim_canal

UNION ALL

SELECT 'dim_cliente', COUNT(*)
FROM dim_cliente

UNION ALL

SELECT 'fato_acionamentos', COUNT(*)
FROM fato_acionamentos

UNION ALL

SELECT 'fato_promessas', COUNT(*)
FROM fato_promessas

UNION ALL

SELECT 'fato_pagamentos', COUNT(*)
FROM fato_pagamentos;