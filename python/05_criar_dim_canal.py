import pandas as pd

# ==========================================
# DIMENSÃO DE CANAL
# ==========================================

canais = [
    [1, "Telefone", "Humano"],
    [2, "WhatsApp", "Digital"],
    [3, "SMS", "Digital"],
    [4, "E-mail", "Digital"]
]

colunas = [
    "canal_id",
    "nome_canal",
    "tipo_canal"
]

df_canais = pd.DataFrame(
    canais,
    columns=colunas
)

# ==========================================
# EXIBIÇÃO
# ==========================================

print("\n===== DIM_CANAL =====\n")
print(df_canais)

print("\n===== TOTAL DE CANAIS =====")
print(len(df_canais))

# ==========================================
# EXPORTAÇÃO PARA CSV
# ==========================================

caminho_saida = "data/raw/dim_canal.csv"

df_canais.to_csv(
    caminho_saida,
    index=False,
    encoding="utf-8-sig"
)

print("\nArquivo salvo com sucesso!")
print(f"Local: {caminho_saida}")    