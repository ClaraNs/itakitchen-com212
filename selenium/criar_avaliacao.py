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
time.sleep(5)

# Esperar até que o botão de adicionar avaliação esteja visível
wait = WebDriverWait(driver, 10)
add_button = wait.until(EC.visibility_of_element_located((By.CSS_SELECTOR, 'ion-fab button.marrom')))

# Clicar no botão de adicionar avaliação
add_button.click()
time.sleep(5)

# Encontre a caixa de pesquisa e digite o nome do estabelecimento
'''search_input = driver.find_element(By.CSS_SELECTOR, 'ion-searchbar input')
search_input.send_keys('CODA Burger')

# Aguarde o carregamento dos resultados da pesquisa
driver.implicitly_wait(5)

# Encontre o primeiro item de resultado da pesquisa e clique nele
# Aguardar um segundo antes de clicar
first_result = driver.find_element(By.CSS_SELECTOR, 'ion-item')

# Role a página para o elemento ficar visível
driver.execute_script("arguments[0].scrollIntoView(true);", first_result)
# Clique no elemento após ele estar visível
first_result.click() '''

xpath = "//ion-list[@class='lista-estab']/ion-item[1]"

# Aguarde até que o item esteja presente na página
wait = WebDriverWait(driver, 10)
item_element = wait.until(EC.presence_of_element_located((By.XPATH, xpath)))

# Clique no item
item_element.click()
time.sleep(5)

# Fecha o navegador
driver.quit()