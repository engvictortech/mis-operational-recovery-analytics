import os
import pandas as pd
import pyodbc


# ============================================================
# CONFIGURAÇÃO
# ============================================================

SERVIDOR = "localhost"
BANCO = "MIS_EXSEN"

PASTA_PROCESSED = os.path.join("data", "processed")


# ============================================================
# CONEXÃO COM SQL SERVER
# ============================================================

connection_string = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    f"SERVER={SERVIDOR};"
    f"DATABASE={BANCO};"
    "Trusted_Connection=yes;"
    "Encrypt=yes;"
    "TrustServerCertificate=yes;"
)


# ============================================================
# ARQUIVOS -> TABELAS DE STAGING
# ============================================================

tabelas = {
    "dim_equipe.csv": "stg_dim_equipe",
    "dim_operador.csv": "stg_dim_operador",
    "dim_produto.csv": "stg_dim_produto",
    "dim_carteira.csv": "stg_dim_carteira",
    "dim_canal.csv": "stg_dim_canal",
    "dim_data.csv": "stg_dim_data",
    "dim_cliente.csv": "stg_dim_cliente",
    "fato_acionamentos.csv": "stg_fato_acionamentos",
    "fato_promessas.csv": "stg_fato_promessas",
    "fato_pagamentos.csv": "stg_fato_pagamentos"
}


# ============================================================
# FUNÇÃO PARA CONVERTER VALORES DO PANDAS
# PARA TIPOS COMPATÍVEIS COM PYODBC
# ============================================================

def converter_valor(valor):
    if pd.isna(valor):
        return None

    if isinstance(valor, pd.Timestamp):
        return valor.to_pydatetime()

    if hasattr(valor, "item"):
        return valor.item()

    return valor


# ============================================================
# CARGA
# ============================================================

try:

    conexao = pyodbc.connect(connection_string)
    cursor = conexao.cursor()

    cursor.fast_executemany = True

    print("=" * 60)
    print("INICIANDO CARGA DA CAMADA STAGING")
    print("=" * 60)

    for arquivo, tabela in tabelas.items():

        caminho = os.path.join(PASTA_PROCESSED, arquivo)

        print(f"\nCarregando: {arquivo}")
        print(f"Destino: {tabela}")

        if not os.path.exists(caminho):
            raise FileNotFoundError(
                f"Arquivo não encontrado: {caminho}"
            )

        # ----------------------------------------------------
        # LEITURA DO CSV
        # ----------------------------------------------------

        df = pd.read_csv(
            caminho,
            encoding="utf-8-sig"
        )

        # Remove espaços dos nomes das colunas
        df.columns = df.columns.str.strip()

        # ----------------------------------------------------
        # LIMPA A TABELA ANTES DA NOVA CARGA
        # ----------------------------------------------------

        cursor.execute(f"TRUNCATE TABLE {tabela}")

        # ----------------------------------------------------
        # MONTA INSERT AUTOMATICAMENTE
        # ----------------------------------------------------

        colunas = list(df.columns)

        nomes_colunas = ", ".join(
            f"[{coluna}]"
            for coluna in colunas
        )

        placeholders = ", ".join(
            "?"
            for _ in colunas
        )

        sql_insert = f"""
            INSERT INTO {tabela}
            ({nomes_colunas})
            VALUES ({placeholders})
        """

        # ----------------------------------------------------
        # CONVERTE OS REGISTROS
        # ----------------------------------------------------

        registros = []

        for linha in df.itertuples(index=False, name=None):

            registro = tuple(
                converter_valor(valor)
                for valor in linha
            )

            registros.append(registro)

        # ----------------------------------------------------
        # INSERE NO SQL SERVER
        # ----------------------------------------------------

        if registros:

            cursor.executemany(
                sql_insert,
                registros
            )

        conexao.commit()

        # ----------------------------------------------------
        # VALIDA QUANTIDADE CARREGADA
        # ----------------------------------------------------

        cursor.execute(
            f"SELECT COUNT(*) FROM {tabela}"
        )

        total_sql = cursor.fetchone()[0]

        print(
            f"CSV: {len(df):,} registros | "
            f"SQL Server: {total_sql:,} registros"
        )

        if len(df) == total_sql:
            print("STATUS: OK")
        else:
            print("STATUS: DIVERGÊNCIA DE QUANTIDADE")


    print("\n" + "=" * 60)
    print("CARGA DA STAGING CONCLUÍDA COM SUCESSO!")
    print("=" * 60)

    cursor.close()
    conexao.close()


except Exception as erro:

    print("\nERRO DURANTE A CARGA:")
    print(erro)

    try:
        conexao.rollback()
        conexao.close()
    except:
        pass