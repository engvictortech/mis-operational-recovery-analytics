import os
import pandas as pd


# ============================================================
# CONFIGURAÇÃO
# ============================================================

data_inicial = "2026-01-01"
data_final = "2027-02-01"

caminho_saida = os.path.join(
    "data",
    "raw",
    "dim_data.csv"
)


# ============================================================
# CRIAÇÃO DO CALENDÁRIO
# ============================================================

datas = pd.date_range(
    start=data_inicial,
    end=data_final,
    freq="D"
)

df_data = pd.DataFrame({
    "data": datas
})


# ============================================================
# ATRIBUTOS DE DATA
# ============================================================

df_data["ano"] = df_data["data"].dt.year

df_data["mes_numero"] = df_data["data"].dt.month


meses = {
    1: "Janeiro",
    2: "Fevereiro",
    3: "Março",
    4: "Abril",
    5: "Maio",
    6: "Junho",
    7: "Julho",
    8: "Agosto",
    9: "Setembro",
    10: "Outubro",
    11: "Novembro",
    12: "Dezembro"
}

df_data["mes_nome"] = (
    df_data["mes_numero"]
    .map(meses)
)


df_data["trimestre"] = (
    "T"
    + df_data["data"]
        .dt.quarter
        .astype(str)
)


df_data["semana_ano"] = (
    df_data["data"]
    .dt.isocalendar()
    .week
    .astype(int)
)


df_data["dia"] = (
    df_data["data"]
    .dt.day
)


df_data["dia_semana_numero"] = (
    df_data["data"]
    .dt.dayofweek
    + 1
)


dias_semana = {
    1: "Segunda-feira",
    2: "Terça-feira",
    3: "Quarta-feira",
    4: "Quinta-feira",
    5: "Sexta-feira",
    6: "Sábado",
    7: "Domingo"
}

df_data["dia_semana_nome"] = (
    df_data["dia_semana_numero"]
    .map(dias_semana)
)


df_data["fim_de_semana"] = (
    df_data["dia_semana_numero"]
    .isin([6, 7])
    .astype(int)
)


df_data["inicio_mes"] = (
    df_data["data"]
    .dt.is_month_start
    .astype(int)
)


df_data["fim_mes"] = (
    df_data["data"]
    .dt.is_month_end
    .astype(int)
)


# ============================================================
# FORMATAÇÃO
# ============================================================

df_data["data"] = (
    df_data["data"]
    .dt.strftime("%Y-%m-%d")
)


# ============================================================
# EXPORTAÇÃO
# ============================================================

df_data.to_csv(
    caminho_saida,
    index=False,
    encoding="utf-8-sig"
)


print("=" * 60)
print("DIMENSÃO DATA GERADA COM SUCESSO!")
print("=" * 60)

print(f"Período: {data_inicial} até {data_final}")
print(f"Quantidade de datas: {len(df_data)}")
print(f"Arquivo: {caminho_saida}")