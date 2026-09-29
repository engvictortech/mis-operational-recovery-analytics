import pandas as pd
import random
from datetime import datetime, timedelta

# ==========================================
# CONFIGURAÇÃO
# ==========================================

quantidade_operadores = 80

# ==========================================
# LISTAS PARA GERAR DADOS FICTÍCIOS
# ==========================================

nomes = [
    "Ana", "Carlos", "Mariana", "João", "Fernanda",
    "Lucas", "Juliana", "Rafael", "Camila", "Bruno",
    "Larissa", "Gabriel", "Amanda", "Felipe", "Beatriz",
    "Diego", "Carolina", "Gustavo", "Letícia", "Rodrigo",
    "Priscila", "Thiago", "Vanessa", "Eduardo", "Patrícia"
]

sobrenomes = [
    "Silva", "Souza", "Santos", "Oliveira", "Costa",
    "Pereira", "Almeida", "Ferreira", "Rodrigues", "Gomes",
    "Martins", "Lima", "Carvalho", "Ribeiro", "Alves"
]

turnos = [
    "Manhã",
    "Tarde",
    "Noite"
]

status = [
    "Ativo",
    "Ativo",
    "Ativo",
    "Ativo",
    "Férias",
    "Afastado"
]

# ==========================================
# GERAÇÃO DOS OPERADORES
# ==========================================

operadores = []

for operador_id in range(1, quantidade_operadores + 1):

    nome = random.choice(nomes)
    sobrenome = random.choice(sobrenomes)

    nome_completo = f"{nome} {sobrenome}"

    equipe_id = random.randint(1, 8)

    cargo = "Operador"

    data_inicio = datetime(2023, 1, 1)
    data_fim = datetime(2026, 6, 30)

    dias = (data_fim - data_inicio).days

    data_admissao = data_inicio + timedelta(
        days=random.randint(0, dias)
    )

    turno = random.choice(turnos)

    situacao = random.choice(status)

    operadores.append([
        operador_id,
        nome_completo,
        equipe_id,
        cargo,
        data_admissao.strftime("%Y-%m-%d"),
        situacao,
        turno
    ])

# ==========================================
# CRIAÇÃO DO DATAFRAME
# ==========================================

colunas = [
    "operador_id",
    "nome_operador",
    "equipe_id",
    "cargo",
    "data_admissao",
    "status",
    "turno"
]

df_operadores = pd.DataFrame(
    operadores,
    columns=colunas
)

# ==========================================
# CONVERSÃO DA DATA
# ==========================================

df_operadores["data_admissao"] = pd.to_datetime(
    df_operadores["data_admissao"]
)

# ==========================================
# VISUALIZAÇÃO
# ==========================================

print("\n===== DIM_OPERADOR =====\n")

print(df_operadores)

print("\n===== TOTAL DE OPERADORES =====")

print(len(df_operadores))

# ==========================================
# EXPORTAÇÃO PARA CSV
# ==========================================

caminho_saida = "data/raw/dim_operador.csv"

df_operadores.to_csv(
    caminho_saida,
    index=False,
    encoding="utf-8-sig"
)

print("\nArquivo salvo com sucesso!")
print(f"Local: {caminho_saida}")