from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

# Configuração do WebDriver (utilize o driver adequado para o seu navegador)
driver = webdriver.Firefox()

# Abre a página de criação do cliente
driver.get("http://localhost:8100")

# Aguarda até que o botão de login seja visível
cadastro_button = WebDriverWait(driver, 10).until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, 'button.btn-inicio.marrom'))
)
cadastro_button.click()  
time.sleep(5)

# Aguarda até que o botão do estabelecimento seja visível
estabelecimento_button = WebDriverWait(driver, 10).until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, 'button.btn-tipo.marrom'))
)

# Clica no botão do estabelecimento desejado para selecionar
estabelecimento_button.click()
time.sleep(5)

# Preencher os campos de e-mail e senha
email_input = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CSS_SELECTOR, 'ion-input[name="email"] input'))
)
email_input.send_keys("estabelecimento@gmail.com")

senha_input = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CSS_SELECTOR, 'ion-input[name="senha"] input'))
)
senha_input.send_keys("senha123")
time.sleep(5)

# Clicar no botão "Continuar"
continuar_button = WebDriverWait(driver, 10).until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, 'button.btn-login'))
)
continuar_button.click()
time.sleep(5)

# Preencher os campos do formulário
nome_input = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CSS_SELECTOR, 'ion-input[name="nome"] input'))
)
nome_input.send_keys("Nome do Estabelecimento")

cnpj_input = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CSS_SELECTOR, 'ion-input[name="cnpj"] input'))
)
cnpj_input.send_keys("12345678901234")

contato_input = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CSS_SELECTOR, 'ion-input[name="contato"] input'))
)
contato_input.send_keys("(12) 34567-8901")

descricao_input = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CSS_SELECTOR, 'ion-input[name="descricao"] input'))
)
descricao_input.send_keys("Descrição do estabelecimento")

categoria_select = WebDriverWait(driver, 10).until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, 'ion-select[name="categoria"]'))
)
categoria_select.click()

categoria_option = WebDriverWait(driver, 10).until(
    EC.element_to_be_clickable((By.XPATH, '//ion-option[contains(text(),"Categoria desejada")]'))
)
categoria_option.click()

# Clicar no botão "Próximo"
proximo_button = WebDriverWait(driver, 10).until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, 'button.btn-login'))
)
proximo_button.click()

# Fecha o navegador
driver.quit()