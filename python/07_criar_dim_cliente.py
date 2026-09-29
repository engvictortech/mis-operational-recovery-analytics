import pandas as pd
import random
from datetime import datetime, timedelta

# ==========================================
# CONFIGURAÇÕES
# ==========================================

quantidade_clientes = 10000

# ==========================================
# LISTAS PARA GERAÇÃO DOS CLIENTES
# ==========================================

nomes = [
    "Ana", "Carlos", "Mariana", "João", "Fernanda",
    "Lucas", "Juliana", "Rafael", "Camila", "Bruno",
    "Larissa", "Gabriel", "Amanda", "Felipe", "Beatriz",
    "Diego", "Carolina", "Gustavo", "Letícia", "Rodrigo",
    "Priscila", "Thiago", "Vanessa", "Eduardo", "Patrícia",
    "Renata", "Marcelo", "Aline", "Daniel", "Bianca"
]

sobrenomes = [
    "Silva", "Souza", "Santos", "Oliveira", "Costa",
    "Pereira", "Almeida", "Ferreira", "Rodrigues", "Gomes",
    "Martins", "Lima", "Carvalho", "Ribeiro", "Alves",
    "Barbosa", "Mendes", "Nunes", "Moreira", "Cardoso"
]

cidades = [
    "São Paulo",
    "Guarulhos",
    "Osasco",
    "Santo André",
    "São Bernardo do Campo",
    "Barueri",
    "Campinas",
    "Jundiaí",
    "Sorocaba",
    "Santos"
]

segmentos = [
    "Pessoa Física",
    "Servidor Público",
    "Aposentado",
    "Militar"
]

status_cliente = [
    "Ativo",
    "Ativo",
    "Ativo",
    "Ativo",
    "Inativo"
]

# ==========================================
# GERAÇÃO DOS CLIENTES
# ==========================================

clientes = []

data_inicio = datetime(2020, 1, 1)
data_fim = datetime(2026, 6, 30)

dias_periodo = (data_fim - data_inicio).days

for cliente_id in range(1, quantidade_clientes + 1):

    nome = random.choice(nomes)
    sobrenome = random.choice(sobrenomes)

    nome_completo = f"{nome} {sobrenome}"

    # CPF totalmente fictício
    cpf_ficticio = f"***.{cliente_id:03d}.***-**"

    cidade = random.choice(cidades)

    idade = random.randint(21, 70)

    segmento = random.choice(segmentos)

    data_cadastro = data_inicio + timedelta(
        days=random.randint(0, dias_periodo)
    )

    status = random.choice(status_cliente)

    clientes.append([
        cliente_id,
        nome_completo,
        cpf_ficticio,
        cidade,
        "SP",
        idade,
        segmento,
        data_cadastro,
        status
    ])

# ==========================================
# DATAFRAME
# ==========================================

colunas = [
    "cliente_id",
    "nome_cliente",
    "cpf_ficticio",
    "cidade",
    "estado",
    "idade",
    "segmento",
    "data_cadastro",
    "status"
]

df_clientes = pd.DataFrame(
    clientes,
    columns=colunas
)

# ==========================================
# AJUSTE DOS TIPOS
# ==========================================

df_clientes["data_cadastro"] = pd.to_datetime(
    df_clientes["data_cadastro"]
)

# ==========================================
# EXIBIÇÃO
# ==========================================

print("\n===== DIM_CLIENTE =====\n")

print(df_clientes.head(10))

print("\n===== TOTAL DE CLIENTES =====")

print(len(df_clientes))

print("\n===== CLIENTES POR SEGMENTO =====")

print(
    df_clientes["segmento"]
    .value_counts()
)

print("\n===== CLIENTES POR STATUS =====")

print(
    df_clientes["status"]
    .value_counts()
)

# ==========================================
# EXPORTAÇÃO
# ==========================================

caminho_saida = "data/raw/dim_cliente.csv"

df_clientes.to_csv(
    caminho_saida,
    index=False,
    encoding="utf-8-sig"
)

print("\nArquivo salvo com sucesso!")

print(f"Local: {caminho_saida}")