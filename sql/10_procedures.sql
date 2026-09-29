USE MIS_EXSEN;
GO

/*
====================================================
PROJETO MIS EXSEN
STORED PROCEDURES
====================================================

Objetivo:
Criar procedimentos armazenados para automatizar
consultas gerenciais utilizadas pelo MIS.

Procedure:
dbo.sp_resumo_mis

Permite consultar indicadores por período.
====================================================
*/


CREATE OR ALTER PROCEDURE dbo.sp_resumo_mis

    @DataInicio DATE = NULL,
    @DataFim DATE = NULL

AS

BEGIN

    SET NOCOUNT ON;


    -- ================================================
    -- DEFINE PERÍODO PADRÃO
    -- ================================================

    IF @DataInicio IS NULL
    BEGIN
        SELECT @DataInicio = MIN(data_acionamento)
        FROM fato_acionamentos;
    END;


    IF @DataFim IS NULL
    BEGIN
        SELECT @DataFim = MAX(data_acionamento)
        FROM fato_acionamentos;
    END;


    -- ================================================
    -- RESUMO EXECUTIVO
    -- ================================================

    SELECT

        @DataInicio AS periodo_inicio,
        @DataFim AS periodo_fim,


        -- ACIONAMENTOS

        (
            SELECT COUNT(*)
            FROM fato_acionamentos
            WHERE data_acionamento
                BETWEEN @DataInicio AND @DataFim
        ) AS total_acionamentos,


        -- CONTATOS EFETIVOS

        (
            SELECT COUNT(*)
            FROM fato_acionamentos
            WHERE data_acionamento
                BETWEEN @DataInicio AND @DataFim

              AND contato_efetivo = 1
        ) AS contatos_efetivos,


        -- TAXA DE CONTATO

        CAST(

            (
                SELECT COUNT(*)
                FROM fato_acionamentos
                WHERE data_acionamento
                    BETWEEN @DataInicio AND @DataFim

                  AND contato_efetivo = 1
            ) * 100.0

            /

            NULLIF(
                (
                    SELECT COUNT(*)
                    FROM fato_acionamentos
                    WHERE data_acionamento
                        BETWEEN @DataInicio AND @DataFim
                ),
                0
            )

            AS DECIMAL(10,2)

        ) AS taxa_contato_percentual,


        -- PROMESSAS

        (
            SELECT COUNT(*)
            FROM fato_promessas
            WHERE data_promessa
                BETWEEN @DataInicio AND @DataFim
        ) AS total_promessas,


        -- CONVERSÃO CONTATO -> PROMESSA

        CAST(

            (
                SELECT COUNT(*)
                FROM fato_acionamentos
                WHERE data_acionamento
                    BETWEEN @DataInicio AND @DataFim

                  AND promessa_pagamento = 1
            ) * 100.0

            /

            NULLIF(
                (
                    SELECT COUNT(*)
                    FROM fato_acionamentos
                    WHERE data_acionamento
                        BETWEEN @DataInicio AND @DataFim

                      AND contato_efetivo = 1
                ),
                0
            )

            AS DECIMAL(10,2)

        ) AS taxa_conversao_percentual,


        -- VALOR PROMETIDO

        CAST(

            (
                SELECT SUM(valor_promessa)
                FROM fato_promessas
                WHERE data_promessa
                    BETWEEN @DataInicio AND @DataFim
            )

            AS DECIMAL(18,2)

        ) AS valor_total_prometido,


        -- VALOR RECUPERADO

        CAST(

            (
                SELECT SUM(valor_pago)
                FROM fato_pagamentos
                WHERE data_pagamento
                    BETWEEN @DataInicio AND @DataFim

                  AND status_pagamento = 'Pago'
            )

            AS DECIMAL(18,2)

        ) AS valor_total_recuperado;

END;

GO


-- ================================================
-- TESTE DA PROCEDURE
-- ================================================

EXEC dbo.sp_resumo_mis
    @DataInicio = '2026-01-01',
    @DataFim = '2026-12-31';