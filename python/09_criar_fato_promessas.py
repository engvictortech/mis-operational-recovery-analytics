import pandas as pd
import random
from datetime import timedelta

# ==========================================
# LEITURA DOS ACIONAMENTOS
# ==========================================

caminho_acionamentos = "data/raw/fato_acionamentos.csv"

df_acionamentos = pd.read_csv(
    caminho_acionamentos
)

# ==========================================
# SELECIONAR SOMENTE CONTATOS COM PROMESSA
# ==========================================

df_promessas = df_acionamentos[
    df_acionamentos["promessa_pagamento"] == 1
].copy()

# ==========================================
# GERAR ID DA PROMESSA
# ==========================================

df_promessas.insert(
    0,
    "promessa_id",
    range(1, len(df_promessas) + 1)
)

# ==========================================
# DATA DA PROMESSA
# ==========================================

df_promessas["data_acionamento"] = pd.to_datetime(
    df_promessas["data_acionamento"]
)

df_promessas["data_promessa"] = (
    df_promessas["data_acionamento"]
    + pd.to_timedelta(
        [random.randint(1, 10) for _ in range(len(df_promessas))],
        unit="D"
    )
)

# ==========================================
# DATA PREVISTA PARA PAGAMENTO
# ==========================================

df_promessas["data_vencimento_promessa"] = (
    df_promessas["data_promessa"]
    + pd.to_timedelta(
        [random.randint(1, 15) for _ in range(len(df_promessas))],
        unit="D"
    )
)

# ==========================================
# STATUS DA PROMESSA
# ==========================================

status = [
    "Paga",
    "Paga",
    "Paga",
    "Pendente",
    "Quebrada"
]

df_promessas["status_promessa"] = [
    random.choice(status)
    for _ in range(len(df_promessas))
]

# ==========================================
# VALOR DA PROMESSA
# ==========================================

df_promessas["valor_promessa"] = df_promessas[
    "valor_promessa"
].round(2)

# ==========================================
# SELECIONAR COLUNAS
# ==========================================

colunas = [
    "promessa_id",
    "data_promessa",
    "data_vencimento_promessa",
    "operador_id",
    "cliente_id",
    "produto_id",
    "carteira_id",
    "canal_id",
    "valor_promessa",
    "status_promessa"
]

df_promessas = df_promessas[
    colunas
]

# ==========================================
# EXIBIÇÃO
# ==========================================

print("\n===== FATO_PROMESSAS =====\n")

print(
    df_promessas.head(10)
)

print("\n===== TOTAL DE PROMESSAS =====")

print(
    len(df_promessas)
)

print("\n===== STATUS DAS PROMESSAS =====")

print(
    df_promessas["status_promessa"]
    .value_counts()
)

print("\n===== VALOR TOTAL DAS PROMESSAS =====")

print(
    round(
        df_promessas["valor_promessa"].sum(),
        2
    )
)

# ==========================================
# EXPORTAÇÃO
# ==========================================

caminho_saida = "data/raw/fato_promessas.csv"

df_promessas.to_csv(
    caminho_saida,
    index=False,
    encoding="utf-8-sig"
)

print("\nArquivo salvo com sucesso!")

print(
    f"Local: {caminho_saida}"
)