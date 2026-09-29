import pyodbc

servidor = "localhost"
banco = "MIS_EXSEN"

connection_string = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    f"SERVER={servidor};"
    f"DATABASE={banco};"
    "Trusted_Connection=yes;"
    "Encrypt=yes;"
    "TrustServerCertificate=yes;"
)

try:
    conexao = pyodbc.connect(connection_string)

    cursor = conexao.cursor()

    cursor.execute("""
        SELECT
            @@SERVERNAME AS servidor,
            DB_NAME() AS banco_atual
    """)

    resultado = cursor.fetchone()

    print("CONEXÃO REALIZADA COM SUCESSO!")
    print(f"Servidor: {resultado.servidor}")
    print(f"Banco atual: {resultado.banco_atual}")

    cursor.close()
    conexao.close()

except Exception as erro:
    print("ERRO AO CONECTAR:")
    print(erro)