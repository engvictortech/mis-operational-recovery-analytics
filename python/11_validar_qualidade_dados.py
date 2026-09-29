import pandas as pd

print("\n==========================================")
print("   VALIDAÇÃO DE QUALIDADE DOS DADOS")
print("==========================================\n")


# ==========================================
# LEITURA DAS BASES
# ==========================================

df_operador = pd.read_csv(
    "data/raw/dim_operador.csv"
)

df_equipe = pd.read_csv(
    "data/raw/dim_equipe.csv"
)

df_produto = pd.read_csv(
    "data/raw/dim_produto.csv"
)

df_carteira = pd.read_csv(
    "data/raw/dim_carteira.csv"
)

df_canal = pd.read_csv(
    "data/raw/dim_canal.csv"
)

df_cliente = pd.read_csv(
    "data/raw/dim_cliente.csv"
)

df_acionamentos = pd.read_csv(
    "data/raw/fato_acionamentos.csv"
)

df_promessas = pd.read_csv(
    "data/raw/fato_promessas.csv"
)

df_pagamentos = pd.read_csv(
    "data/raw/fato_pagamentos.csv"
)


# ==========================================
# 1. VOLUME DAS TABELAS
# ==========================================

print("===== VOLUME DAS TABELAS =====\n")

print(
    f"dim_operador:      {len(df_operador):,}"
)

print(
    f"dim_equipe:        {len(df_equipe):,}"
)

print(
    f"dim_produto:       {len(df_produto):,}"
)

print(
    f"dim_carteira:      {len(df_carteira):,}"
)

print(
    f"dim_canal:         {len(df_canal):,}"
)

print(
    f"dim_cliente:       {len(df_cliente):,}"
)

print(
    f"fato_acionamentos:  {len(df_acionamentos):,}"
)

print(
    f"fato_promessas:     {len(df_promessas):,}"
)

print(
    f"fato_pagamentos:    {len(df_pagamentos):,}"
)


# ==========================================
# 2. DUPLICIDADES
# ==========================================

print("\n===== DUPLICIDADES =====\n")

print(
    "Operadores duplicados:",
    df_operador["operador_id"].duplicated().sum()
)

print(
    "Equipes duplicadas:",
    df_equipe["equipe_id"].duplicated().sum()
)

print(
    "Produtos duplicados:",
    df_produto["produto_id"].duplicated().sum()
)

print(
    "Carteiras duplicadas:",
    df_carteira["carteira_id"].duplicated().sum()
)

print(
    "Canais duplicados:",
    df_canal["canal_id"].duplicated().sum()
)

print(
    "Clientes duplicados:",
    df_cliente["cliente_id"].duplicated().sum()
)

print(
    "Acionamentos duplicados:",
    df_acionamentos["acionamento_id"].duplicated().sum()
)

print(
    "Promessas duplicadas:",
    df_promessas["promessa_id"].duplicated().sum()
)

print(
    "Pagamentos duplicados:",
    df_pagamentos["pagamento_id"].duplicated().sum()
)


# ==========================================
# 3. VALORES NULOS
# ==========================================

print("\n===== VALORES NULOS =====\n")

print(
    "Acionamentos:",
    df_acionamentos.isnull().sum().sum()
)

print(
    "Promessas:",
    df_promessas.isnull().sum().sum()
)

print(
    "Pagamentos:",
    df_pagamentos.isnull().sum().sum()
)


# ==========================================
# 4. CHAVES ESTRANGEIRAS
# ==========================================

print("\n===== INTEGRIDADE DAS CHAVES =====\n")


operadores_invalidos = (
    ~df_acionamentos["operador_id"]
    .isin(df_operador["operador_id"])
).sum()

clientes_invalidos = (
    ~df_acionamentos["cliente_id"]
    .isin(df_cliente["cliente_id"])
).sum()

produtos_invalidos = (
    ~df_acionamentos["produto_id"]
    .isin(df_produto["produto_id"])
).sum()

carteiras_invalidas = (
    ~df_acionamentos["carteira_id"]
    .isin(df_carteira["carteira_id"])
).sum()

canais_invalidos = (
    ~df_acionamentos["canal_id"]
    .isin(df_canal["canal_id"])
).sum()


print(
    "Operadores inválidos:",
    operadores_invalidos
)

print(
    "Clientes inválidos:",
    clientes_invalidos
)

print(
    "Produtos inválidos:",
    produtos_invalidos
)

print(
    "Carteiras inválidas:",
    carteiras_invalidas
)

print(
    "Canais inválidos:",
    canais_invalidos
)


# ==========================================
# 5. VALORES NEGATIVOS
# ==========================================

print("\n===== VALORES NEGATIVOS =====\n")

negativos_promessas = (
    df_promessas["valor_promessa"] < 0
).sum()

negativos_pagamentos = (
    df_pagamentos["valor_pago"] < 0
).sum()


print(
    "Valores negativos em promessas:",
    negativos_promessas
)

print(
    "Valores negativos em pagamentos:",
    negativos_pagamentos
)


# ==========================================
# 6. CONSISTÊNCIA DAS PROMESSAS
# ==========================================

print("\n===== CONSISTÊNCIA DAS PROMESSAS =====\n")

promessas_invalidas = (
    df_promessas["valor_promessa"] <= 0
).sum()

print(
    "Promessas com valor inválido:",
    promessas_invalidas
)


# ==========================================
# 7. CONSISTÊNCIA DOS PAGAMENTOS
# ==========================================

print("\n===== CONSISTÊNCIA DOS PAGAMENTOS =====\n")

pagamentos_invalidos = (
    (df_pagamentos["status_pagamento"] == "Pago")
    &
    (df_pagamentos["valor_pago"] <= 0)
).sum()

print(
    "Pagamentos pagos com valor inválido:",
    pagamentos_invalidos
)


# ==========================================
# RESULTADO FINAL
# ==========================================

print("\n==========================================")
print("       VALIDAÇÃO FINALIZADA")
print("==========================================")

print("\nNenhum tratamento foi realizado.")
print("Esta etapa apenas identificou possíveis problemas.")