import pandas as pd
import random

# ==========================================
# LEITURA DAS PROMESSAS
# ==========================================

caminho_promessas = "data/raw/fato_promessas.csv"

df_promessas = pd.read_csv(
    caminho_promessas
)

# ==========================================
# CONVERSÃO DAS DATAS
# ==========================================

df_promessas["data_promessa"] = pd.to_datetime(
    df_promessas["data_promessa"]
)

df_promessas["data_vencimento_promessa"] = pd.to_datetime(
    df_promessas["data_vencimento_promessa"]
)

# ==========================================
# SELECIONAR PROMESSAS COM POSSIBILIDADE
# DE PAGAMENTO
# ==========================================

df_pagamentos = df_promessas[
    df_promessas["status_promessa"].isin(
        ["Paga", "Pendente"]
    )
].copy()

# ==========================================
# ID DO PAGAMENTO
# ==========================================

df_pagamentos.insert(
    0,
    "pagamento_id",
    range(1, len(df_pagamentos) + 1)
)

# ==========================================
# DEFINIR STATUS REAL DO PAGAMENTO
# ==========================================

status_pagamento = []

for _, linha in df_pagamentos.iterrows():

    if linha["status_promessa"] == "Paga":
        status = "Pago"
    else:
        status = random.choices(
            ["Pago", "Pendente"],
            weights=[40, 60],
            k=1
        )[0]

    status_pagamento.append(status)

df_pagamentos["status_pagamento"] = status_pagamento

# ==========================================
# DATA DO PAGAMENTO
# ==========================================

datas_pagamento = []

for _, linha in df_pagamentos.iterrows():

    if linha["status_pagamento"] == "Pago":

        data_base = linha["data_vencimento_promessa"]

        atraso = random.randint(0, 10)

        data_pagamento = (
            data_base
            + pd.Timedelta(days=atraso)
        )

    else:

        data_pagamento = pd.NaT

    datas_pagamento.append(data_pagamento)

df_pagamentos["data_pagamento"] = datas_pagamento

# ==========================================
# VALOR PAGO
# ==========================================

valores_pagamento = []

for _, linha in df_pagamentos.iterrows():

    if linha["status_pagamento"] == "Pago":

        percentual = random.uniform(
            0.70,
            1.00
        )

        valor = round(
            linha["valor_promessa"] * percentual,
            2
        )

    else:

        valor = 0.0

    valores_pagamento.append(valor)

df_pagamentos["valor_pago"] = valores_pagamento

# ==========================================
# SELECIONAR COLUNAS
# ==========================================

colunas = [
    "pagamento_id",
    "data_pagamento",
    "operador_id",
    "cliente_id",
    "produto_id",
    "carteira_id",
    "canal_id",
    "promessa_id",
    "valor_pago",
    "status_pagamento"
]

df_pagamentos = df_pagamentos[
    colunas
]

# ==========================================
# EXIBIÇÃO
# ==========================================

print("\n===== FATO_PAGAMENTOS =====\n")

print(
    df_pagamentos.head(10)
)

print("\n===== TOTAL DE REGISTROS =====")

print(
    len(df_pagamentos)
)

print("\n===== PAGAMENTOS REALIZADOS =====")

print(
    (
        df_pagamentos["status_pagamento"] == "Pago"
    ).sum()
)

print("\n===== VALOR TOTAL RECUPERADO =====")

print(
    round(
        df_pagamentos[
            "valor_pago"
        ].sum(),
        2
    )
)

print("\n===== STATUS DOS PAGAMENTOS =====")

print(
    df_pagamentos[
        "status_pagamento"
    ].value_counts()
)

# ==========================================
# EXPORTAÇÃO
# ==========================================

caminho_saida = "data/raw/fato_pagamentos.csv"

df_pagamentos.to_csv(
    caminho_saida,
    index=False,
    encoding="utf-8-sig"
)

print("\nArquivo salvo com sucesso!")

print(
    f"Local: {caminho_saida}"
)