import pandas as pd
import os

# ==========================================
# CONFIGURAÇÕES
# ==========================================

pasta_raw = "data/raw"
pasta_processed = "data/processed"

# Criar pasta processed caso não exista
os.makedirs(pasta_processed, exist_ok=True)

print("\n==========================================")
print("       PROCESSAMENTO DA CAMADA STAGING")
print("==========================================\n")


# ==========================================
# LISTA DE ARQUIVOS
# ==========================================

arquivos = [
    "dim_operador.csv",
    "dim_equipe.csv",
    "dim_produto.csv",
    "dim_carteira.csv",
    "dim_canal.csv",
    "dim_data.csv",
    "dim_cliente.csv",
    "fato_acionamentos.csv",
    "fato_promessas.csv",
    "fato_pagamentos.csv"
]


# ==========================================
# PROCESSAMENTO
# ==========================================

for arquivo in arquivos:

    caminho_entrada = os.path.join(
        pasta_raw,
        arquivo
    )

    caminho_saida = os.path.join(
        pasta_processed,
        arquivo
    )

    print(f"Processando: {arquivo}")

    # Ler arquivo
    df = pd.read_csv(
        caminho_entrada
    )

    # Remover espaços extras dos nomes das colunas
    df.columns = (
        df.columns
        .str.strip()
    )

    # Remover registros completamente vazios
    df = df.dropna(
        how="all"
    )

    # Remover duplicidades
    df = df.drop_duplicates()

    # Salvar arquivo tratado
    df.to_csv(
        caminho_saida,
        index=False,
        encoding="utf-8-sig"
    )

    print(
        f"  Registros: {len(df):,}"
    )

    print(
        f"  Salvo em: {caminho_saida}"
    )

    print()


# ==========================================
# FINALIZAÇÃO
# ==========================================

print("==========================================")
print("       STAGING CONCLUÍDO COM SUCESSO")
print("==========================================")