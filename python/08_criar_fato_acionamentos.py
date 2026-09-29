import pandas as pd
import random
from datetime import datetime, timedelta

# ==========================================
# CONFIGURAÇÕES
# ==========================================

quantidade_acionamentos = 50000

# ==========================================
# LISTAS DE APOIO
# ==========================================

resultados = [
    "Contato efetivo",
    "Sem contato",
    "Número inválido",
    "Recado com terceiro",
    "Cliente indisponível"
]

canais = [1, 2, 3, 4]

# ==========================================
# PERÍODO DA OPERAÇÃO
# ==========================================

data_inicio = datetime(2026, 1, 1)
data_fim = datetime(2026, 12, 31)

dias_periodo = (data_fim - data_inicio).days

# ==========================================
# GERAÇÃO DOS ACIONAMENTOS
# ==========================================

acionamentos = []

for acionamento_id in range(1, quantidade_acionamentos + 1):

    data_acionamento = data_inicio + timedelta(
        days=random.randint(0, dias_periodo)
    )

    operador_id = random.randint(1, 80)

    cliente_id = random.randint(1, 10000)

    produto_id = random.randint(1, 5)

    carteira_id = random.randint(1, 6)

    canal_id = random.choice(canais)

    quantidade_tentativas = random.randint(1, 5)

    resultado = random.choices(
        resultados,
        weights=[45, 30, 10, 8, 7],
        k=1
    )[0]

    # ======================================
    # CONTATO EFETIVO
    # ======================================

    if resultado == "Contato efetivo":
        contato_efetivo = 1
    else:
        contato_efetivo = 0

    # ======================================
    # PROMESSA DE PAGAMENTO
    # ======================================

    if contato_efetivo == 1 and random.random() < 0.30:
        promessa_pagamento = 1
    else:
        promessa_pagamento = 0

    # ======================================
    # VALOR DA PROMESSA
    # ======================================

    if promessa_pagamento == 1:
        valor_promessa = round(
            random.uniform(100, 3000),
            2
        )
    else:
        valor_promessa = 0.0

    acionamentos.append([
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
    ])

# ==========================================
# DATAFRAME
# ==========================================

colunas = [
    "acionamento_id",
    "data_acionamento",
    "operador_id",
    "cliente_id",
    "produto_id",
    "carteira_id",
    "canal_id",
    "quantidade_tentativas",
    "resultado",
    "contato_efetivo",
    "promessa_pagamento",
    "valor_promessa"
]

df_acionamentos = pd.DataFrame(
    acionamentos,
    columns=colunas
)

# ==========================================
# AJUSTE DOS TIPOS
# ==========================================

df_acionamentos["data_acionamento"] = pd.to_datetime(
    df_acionamentos["data_acionamento"]
)

# ==========================================
# EXIBIÇÃO
# ==========================================

print("\n===== FATO_ACIONAMENTOS =====\n")

print(
    df_acionamentos.head(10)
)

print("\n===== TOTAL DE ACIONAMENTOS =====")

print(
    len(df_acionamentos)
)

print("\n===== CONTATOS EFETIVOS =====")

print(
    df_acionamentos["contato_efetivo"].sum()
)

print("\n===== PROMESSAS DE PAGAMENTO =====")

print(
    df_acionamentos["promessa_pagamento"].sum()
)

print("\n===== VALOR TOTAL EM PROMESSAS =====")

print(
    round(
        df_acionamentos["valor_promessa"].sum(),
        2
    )
)

# ==========================================
# EXPORTAÇÃO
# ==========================================

caminho_saida = "data/raw/fato_acionamentos.csv"

df_acionamentos.to_csv(
    caminho_saida,
    index=False,
    encoding="utf-8-sig"
)

print("\nArquivo salvo com sucesso!")

print(
    f"Local: {caminho_saida}"
)