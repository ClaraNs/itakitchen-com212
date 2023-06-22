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

cliente_button = WebDriverWait(driver, 10).until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, 'button.btn-tipo'))
)

cliente_button.click()
time.sleep(5)

# Preencher os campos de e-mail e senha
email_input = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CSS_SELECTOR, 'ion-input[name="email"] input'))
)
email_input.send_keys("selenium@gmail.com")

senha_input = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CSS_SELECTOR, 'ion-input[name="senha"] input'))
)
senha_input.send_keys("senha123")

# Clicar no botão "Continuar"
continuar_button = WebDriverWait(driver, 10).until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, 'button.btn-login'))
)
continuar_button.click()
time.sleep(5)

# Preencher os campos de cadastro de cliente
nome_input = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CSS_SELECTOR, 'ion-input[name="nome"] input'))
)
nome_input.send_keys("Nome Completo")

cpf_input = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CSS_SELECTOR, 'ion-input[name="cpf"] input'))
)
cpf_input.send_keys("12345678900")

datanas_input = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CSS_SELECTOR, 'ion-input[name="datanas"] input'))
)
datanas_input.send_keys("2000-01-01")

# Executar código JavaScript para selecionar o tipo de cliente
tipo_select = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CSS_SELECTOR, 'ion-select[name="tipocli"]'))
)
driver.execute_script("arguments[0].click();", tipo_select)

tipo_option = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CSS_SELECTOR, 'ion-option[value="2"]'))  # Altere o valor para o tipo desejado
)
driver.execute_script("arguments[0].click();", tipo_option)

# Anexar foto de perfil (opcional)
arquivo_input = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CSS_SELECTOR, 'input[name="arquivo"]'))
)
arquivo_input.send_keys("perfil.jpg")

time.sleep(5)
# Clicar no botão "Finalizar"
finalizar_button = WebDriverWait(driver, 10).until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, 'button.btn-login'))
)
finalizar_button.click()
time.sleep(5)

# Fecha o navegador
driver.quit()