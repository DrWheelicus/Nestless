from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup
import json

LOGIN_URL = 'https://secure.birds.cornell.edu/cassso/login?service=https%3A%2F%2Febird.org%2Flogin%2Fcas%3Fportal%3Debird&locale=en_CA'
PASSWORD = 'ENTER-PASSWORD-HERE'
USERNAME = 'ENTER-USERNAME-HERE'
regionList = [
    {'region':'York', 'short': 'YO'}, {'region':'Durham', 'short': 'DR'}, 
    {'region':'Niagara County', 'short': 'NG'}, {'region':'Muskoka County', 'short': 'MU'}, 
    {'region':'Toronto', 'short': 'TO'}, {'region':'Simcoe', 'short': 'SC'}, 
    {'region':'Peel', 'short': 'PL'}, {'region':'Halton', 'short': 'HT'}, 
    {'region':'Waterloo', 'short': 'WT'}, {'region':'Kawartha Lakes','short': 'VI'}, 
    {'region':'Haliburton', 'short': 'HB'}, {'region':'Hastings', 'short': 'HS'},
    {'region':'Frontenac', 'short': 'FR'}, {'region':'Nipissing', 'short': 'NP'}, 
    {'region':'Parry Sound', 'short': 'PS'}, {'region':'Ottawa', 'short': 'OT'}, 
    {'region':'Kenora', 'short': 'KR'}, {'region':'Huron', 'short': 'HU'}, 
    {'region':'Oxford', 'short': 'OX'}, {'region':'Thunder bay', 'short': 'TB'}, 
    {'region':'Cochrane', 'short': 'CO'}, {'region':'Sudbury', 'short': 'SB'}, 
    {'region':'Renfrew', 'short': 'RE'}, {'region':'Middlesex', 'short': 'MI'}
]

options = Options()
options.add_argument('headless')
driver = webdriver.Chrome(options=options)

#Login to account
driver.get(LOGIN_URL)
usernameInput = driver.find_element(By.ID, 'input-user-name')
passwordInput = driver.find_element(By.ID, 'input-password')
usernameInput.send_keys(USERNAME)
passwordInput.send_keys(PASSWORD + Keys.ENTER)

birds = {}
for regionDict in regionList:
    region = regionDict['region']
    short = regionDict['short']
    baseUrl = f'https://ebird.org/targets?region={region}%2C+Ontario%2C+Canada+%28CA%29&r1=CA-ON-{short}&bmo=1&emo=12&r2=CA-ON-{short}&t2=life&mediaType='
    driver.get(baseUrl)
    soup = BeautifulSoup(driver.page_source, 'html.parser')

    for row in soup.findAll('div', class_='ResultsStats ResultsStats--action ResultsStats--toEdge'):
        popPercentage = row.find('span', class_='StatsIcon-stat-count').text.replace('%','')
        if float(popPercentage) < 1:
            break

        name = str(row.find('h5', class_='SpecimenHeader-joined u-inline-xs').a.text.strip())
        if name in birds:
            birds.get(name)[region] = str(popPercentage)
        else:
            birds[name] = {region : str(popPercentage)}

with open('eBird-Data.json', 'w') as outfile:
    json.dump(birds, outfile)
driver.quit()