import pandas as pd

# ==========================================
# DIMENSÃO DE EQUIPE
# ==========================================

equipes = [
    [1, "Equipe Alfa", "Cobrança", "Manhã"],
    [2, "Equipe Beta", "Cobrança", "Manhã"],
    [3, "Equipe Gama", "Cobrança", "Tarde"],
    [4, "Equipe Delta", "Cobrança", "Tarde"],
    [5, "Equipe Epsilon", "Retenção", "Manhã"],
    [6, "Equipe Zeta", "Retenção", "Tarde"],
    [7, "Equipe Eta", "Reconquista", "Manhã"],
    [8, "Equipe Theta", "Reconquista", "Tarde"]
]

colunas = [
    "equipe_id",
    "nome_equipe",
    "operacao",
    "turno"
]

df_equipes = pd.DataFrame(
    equipes,
    columns=colunas
)

# ==========================================
# EXIBIÇÃO
# ==========================================

print("\n===== DIM_EQUIPE =====\n")
print(df_equipes)

print("\n===== TOTAL DE EQUIPES =====")
print(len(df_equipes))

# ==========================================
# EXPORTAÇÃO PARA CSV
# ==========================================

caminho_saida = "data/raw/dim_equipe.csv"

df_equipes.to_csv(
    caminho_saida,
    index=False,
    encoding="utf-8-sig"
)

print("\nArquivo salvo com sucesso!")
print(f"Local: {caminho_saida}")