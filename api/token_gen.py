import random
import string

def gerar_codigo(tamanho=6, caracteres=string.ascii_letters + string.digits):
    return ''.join(random.choice(caracteres) for _ in range(tamanho))

s = gerar_codigo()

def gerar_token(email: str) -> str:
    return s


