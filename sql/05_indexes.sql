/*
====================================================
PROJETO MIS EXSEN
ÍNDICES DE PERFORMANCE
====================================================

Objetivo:
Criar índices para melhorar o desempenho das
consultas sobre as tabelas fato e dimensões.

Os índices serão concentrados principalmente nas
chaves estrangeiras e campos utilizados em filtros.
====================================================
*/


-- ================================================
-- 1. DIM_OPERADOR
-- ================================================

CREATE INDEX IX_dim_operador_equipe
ON dim_operador(equipe_id);


-- ================================================
-- 2. FATO ACIONAMENTOS
-- ================================================

CREATE INDEX IX_fato_acionamentos_data
ON fato_acionamentos(data_acionamento);

CREATE INDEX IX_fato_acionamentos_operador
ON fato_acionamentos(operador_id);

CREATE INDEX IX_fato_acionamentos_cliente
ON fato_acionamentos(cliente_id);

CREATE INDEX IX_fato_acionamentos_produto
ON fato_acionamentos(produto_id);

CREATE INDEX IX_fato_acionamentos_carteira
ON fato_acionamentos(carteira_id);

CREATE INDEX IX_fato_acionamentos_canal
ON fato_acionamentos(canal_id);


-- ================================================
-- 3. FATO PROMESSAS
-- ================================================

CREATE INDEX IX_fato_promessas_data
ON fato_promessas(data_promessa);

CREATE INDEX IX_fato_promessas_vencimento
ON fato_promessas(data_vencimento_promessa);

CREATE INDEX IX_fato_promessas_operador
ON fato_promessas(operador_id);

CREATE INDEX IX_fato_promessas_cliente
ON fato_promessas(cliente_id);

CREATE INDEX IX_fato_promessas_produto
ON fato_promessas(produto_id);

CREATE INDEX IX_fato_promessas_carteira
ON fato_promessas(carteira_id);

CREATE INDEX IX_fato_promessas_canal
ON fato_promessas(canal_id);


-- ================================================
-- 4. FATO PAGAMENTOS
-- ================================================

CREATE INDEX IX_fato_pagamentos_data
ON fato_pagamentos(data_pagamento);

CREATE INDEX IX_fato_pagamentos_operador
ON fato_pagamentos(operador_id);

CREATE INDEX IX_fato_pagamentos_cliente
ON fato_pagamentos(cliente_id);

CREATE INDEX IX_fato_pagamentos_produto
ON fato_pagamentos(produto_id);

CREATE INDEX IX_fato_pagamentos_carteira
ON fato_pagamentos(carteira_id);

CREATE INDEX IX_fato_pagamentos_canal
ON fato_pagamentos(canal_id);

CREATE INDEX IX_fato_pagamentos_promessa
ON fato_pagamentos(promessa_id);