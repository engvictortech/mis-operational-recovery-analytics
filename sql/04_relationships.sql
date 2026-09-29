USE MIS_EXSEN;
GO

/*
====================================================
PROJETO MIS EXSEN
RELACIONAMENTOS E INTEGRIDADE REFERENCIAL
====================================================

Objetivo:
Criar relacionamentos entre dimensões e fatos
através de chaves estrangeiras.

Modelo:
STAR SCHEMA
====================================================
*/


-- ================================================
-- 1. OPERADOR -> EQUIPE
-- ================================================

ALTER TABLE dim_operador
ADD CONSTRAINT FK_dim_operador_equipe
FOREIGN KEY (equipe_id)
REFERENCES dim_equipe(equipe_id);


-- ================================================
-- 2. FATO ACIONAMENTOS
-- ================================================

ALTER TABLE fato_acionamentos
ADD CONSTRAINT FK_acionamentos_operador
FOREIGN KEY (operador_id)
REFERENCES dim_operador(operador_id);

ALTER TABLE fato_acionamentos
ADD CONSTRAINT FK_acionamentos_cliente
FOREIGN KEY (cliente_id)
REFERENCES dim_cliente(cliente_id);

ALTER TABLE fato_acionamentos
ADD CONSTRAINT FK_acionamentos_produto
FOREIGN KEY (produto_id)
REFERENCES dim_produto(produto_id);

ALTER TABLE fato_acionamentos
ADD CONSTRAINT FK_acionamentos_carteira
FOREIGN KEY (carteira_id)
REFERENCES dim_carteira(carteira_id);

ALTER TABLE fato_acionamentos
ADD CONSTRAINT FK_acionamentos_canal
FOREIGN KEY (canal_id)
REFERENCES dim_canal(canal_id);


-- ================================================
-- 3. FATO PROMESSAS
-- ================================================

ALTER TABLE fato_promessas
ADD CONSTRAINT FK_promessas_operador
FOREIGN KEY (operador_id)
REFERENCES dim_operador(operador_id);

ALTER TABLE fato_promessas
ADD CONSTRAINT FK_promessas_cliente
FOREIGN KEY (cliente_id)
REFERENCES dim_cliente(cliente_id);

ALTER TABLE fato_promessas
ADD CONSTRAINT FK_promessas_produto
FOREIGN KEY (produto_id)
REFERENCES dim_produto(produto_id);

ALTER TABLE fato_promessas
ADD CONSTRAINT FK_promessas_carteira
FOREIGN KEY (carteira_id)
REFERENCES dim_carteira(carteira_id);

ALTER TABLE fato_promessas
ADD CONSTRAINT FK_promessas_canal
FOREIGN KEY (canal_id)
REFERENCES dim_canal(canal_id);


-- ================================================
-- 4. FATO PAGAMENTOS
-- ================================================

ALTER TABLE fato_pagamentos
ADD CONSTRAINT FK_pagamentos_operador
FOREIGN KEY (operador_id)
REFERENCES dim_operador(operador_id);

ALTER TABLE fato_pagamentos
ADD CONSTRAINT FK_pagamentos_cliente
FOREIGN KEY (cliente_id)
REFERENCES dim_cliente(cliente_id);

ALTER TABLE fato_pagamentos
ADD CONSTRAINT FK_pagamentos_produto
FOREIGN KEY (produto_id)
REFERENCES dim_produto(produto_id);

ALTER TABLE fato_pagamentos
ADD CONSTRAINT FK_pagamentos_carteira
FOREIGN KEY (carteira_id)
REFERENCES dim_carteira(carteira_id);

ALTER TABLE fato_pagamentos
ADD CONSTRAINT FK_pagamentos_canal
FOREIGN KEY (canal_id)
REFERENCES dim_canal(canal_id);

ALTER TABLE fato_pagamentos
ADD CONSTRAINT FK_pagamentos_promessa
FOREIGN KEY (promessa_id)
REFERENCES fato_promessas(promessa_id);

GO


-- ================================================
-- VALIDAÇÃO DOS RELACIONAMENTOS
-- ================================================

SELECT
    fk.name AS foreign_key,
    OBJECT_NAME(fk.parent_object_id) AS tabela_origem,
    OBJECT_NAME(fk.referenced_object_id) AS tabela_destino
FROM sys.foreign_keys fk
ORDER BY tabela_origem, foreign_key;