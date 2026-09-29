/*
========================================================
PROJETO MIS EXSEN
GUIA PRINCIPAL DE EXECUÇÃO
========================================================

Projeto demonstrativo de MIS para operação sintética
de cobrança e contact center.

IMPORTANTE:
- Os dados utilizados são 100% sintéticos.
- Este arquivo funciona como guia de execução.
- Os scripts permanecem separados para facilitar
  manutenção, auditoria e troubleshooting.

========================================================
ORDEM GERAL DO PIPELINE
========================================================

01 - Criar Staging
02 - Criar Dimensões
03 - Criar Fatos
04 - Criar Relacionamentos
05 - Criar Índices
06 - Criar Views
07 - Carregar arquivos processados na Staging (Python)
08 - Carregar Modelo Dimensional
09 - Executar KPIs
10 - Executar Data Quality
11 - Criar Stored Procedures
12 - Criar View de Data Quality

========================================================
*/


-- =====================================================
-- ETAPA 01
-- STAGING
-- =====================================================

-- Executar:
-- 01_staging.sql


-- =====================================================
-- ETAPA 02
-- DIMENSÕES
-- =====================================================

-- Executar:
-- 02_dimensions.sql


-- =====================================================
-- ETAPA 03
-- FATOS
-- =====================================================

-- Executar:
-- 03_facts.sql


-- =====================================================
-- ETAPA 04
-- RELACIONAMENTOS
-- =====================================================

-- Executar:
-- 04_relationships.sql


-- =====================================================
-- ETAPA 05
-- ÍNDICES
-- =====================================================

-- Executar:
-- 05_indexes.sql


-- =====================================================
-- ETAPA 06
-- VIEWS ANALÍTICAS
-- =====================================================

-- Executar:
-- 06_views.sql


-- =====================================================
-- ETAPA 07
-- CARGA DA STAGING
-- =====================================================

-- Executar via Python:
-- python/14_carregar_staging_sqlserver.py

-- Responsável por carregar os arquivos de:
-- data/processed/
--
-- para as tabelas:
-- stg_*


-- =====================================================
-- ETAPA 08
-- CARGA DO MODELO DIMENSIONAL
-- =====================================================

-- Executar:
-- 09_carga_modelo.sql


-- =====================================================
-- ETAPA 09
-- KPIs E CONSULTAS ANALÍTICAS
-- =====================================================

-- Executar:
-- 07_kpis.sql


-- =====================================================
-- ETAPA 10
-- DATA QUALITY
-- =====================================================

-- Executar:
-- 08_data_quality.sql


-- =====================================================
-- ETAPA 11
-- STORED PROCEDURES
-- =====================================================

-- Executar:
-- 10_procedures.sql


-- =====================================================
-- ETAPA 12
-- VIEW DE DATA QUALITY
-- =====================================================

-- Executar:
-- 11_view_data_quality.sql


/*
========================================================
RESULTADO ESPERADO
========================================================

Ao final do pipeline, o banco MIS_EXSEN deverá conter:

DIMENSÕES
---------
dim_data
dim_cliente
dim_operador
dim_equipe
dim_produto
dim_carteira
dim_canal

FATOS
-----
fato_acionamentos
fato_promessas
fato_pagamentos

VIEWS
-----
vw_acionamentos_operacional
vw_promessas_operacional
vw_pagamentos_operacional
vw_performance_operacional
vw_data_quality

PROCEDURE
---------
dbo.sp_resumo_mis

O modelo estará disponível para consumo pelo
dashboard Power BI do projeto.

========================================================
*/
