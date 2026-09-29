import pandas as pd

# ==========================================
# DIMENSÃO DE PRODUTO
# ==========================================

produtos = [
    [1, "Empréstimo Pessoal", "Crédito"],
    [2, "Consignado", "Crédito"],
    [3, "Cartão de Crédito", "Cartão"],
    [4, "Crédito Pessoal", "Crédito"],
    [5, "Financiamento", "Financiamento"]
]

colunas = [
    "produto_id",
    "nome_produto",
    "categoria"
]

df_produtos = pd.DataFrame(
    produtos,
    columns=colunas
)

# ==========================================
# EXIBIÇÃO
# ==========================================

print("\n===== DIM_PRODUTO =====\n")
print(df_produtos)

print("\n===== TOTAL DE PRODUTOS =====")
print(len(df_produtos))

# ==========================================
# EXPORTAÇÃO PARA CSV
# ==========================================

caminho_saida = "data/raw/dim_produto.csv"

df_produtos.to_csv(
    caminho_saida,
    index=False,
    encoding="utf-8-sig"
)

print("\nArquivo salvo com sucesso!")
print(f"Local: {caminho_saida}")