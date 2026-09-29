import pandas as pd

# ==========================================
# DIMENSÃO DE CARTEIRA
# ==========================================

carteiras = [
    [1, "Carteira 01", "1 a 30 dias", 1, 30],
    [2, "Carteira 02", "31 a 60 dias", 31, 60],
    [3, "Carteira 03", "61 a 90 dias", 61, 90],
    [4, "Carteira 04", "91 a 180 dias", 91, 180],
    [5, "Carteira 05", "181 a 360 dias", 181, 360],
    [6, "Carteira 06", "Acima de 360 dias", 361, 9999]
]

colunas = [
    "carteira_id",
    "nome_carteira",
    "faixa_atraso",
    "dias_atraso_min",
    "dias_atraso_max"
]

df_carteiras = pd.DataFrame(
    carteiras,
    columns=colunas
)

# ==========================================
# EXIBIÇÃO
# ==========================================

print("\n===== DIM_CARTEIRA =====\n")
print(df_carteiras)

print("\n===== TOTAL DE CARTEIRAS =====")
print(len(df_carteiras))

# ==========================================
# EXPORTAÇÃO PARA CSV
# ==========================================

caminho_saida = "data/raw/dim_carteira.csv"

df_carteiras.to_csv(
    caminho_saida,
    index=False,
    encoding="utf-8-sig"
)

print("\nArquivo salvo com sucesso!")
print(f"Local: {caminho_saida}")