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
login_button = WebDriverWait(driver, 10).until(EC.visibility_of_element_located((By.CSS_SELECTOR, ".btn-inicio")))
    
# Clica no botão de login
login_button.click()
time.sleep(10)

# Localizar os elementos de e-mail e senha
email_input = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CSS_SELECTOR, 'ion-input[name="email"] input'))
)
senha_input = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.CSS_SELECTOR, 'ion-input[name="senha"] input'))
)

# Preencher os campos de e-mail e senha
email_input.send_keys("ana@gmail.com")
senha_input.send_keys("senha123")

# Localizar e clicar no botão de login
login_button = WebDriverWait(driver, 10).until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, 'button.btn-login'))
)
login_button.click()
time.sleep(20)

# Fecha o navegador
driver.quit()