from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup
import json

BASE_URL = 'https://inaturalist.ca/check_lists/588415-Birds-of-Ontario?'
options = Options()
options.add_argument('headless')
driver = webdriver.Chrome(options=options)
birdList = []

for page in range(11):
    driver.get(BASE_URL + f'page={page+1}')
    soup = BeautifulSoup(driver.page_source, 'html.parser')

    birdGrid = soup.find(class_='clear photo_view listed_taxa')
    for card in birdGrid.findAll('li', class_='listed_taxon_photo'):
        #Find names
        commonName = card.find('span', class_='comname').text.strip()
        sciName = card.find('span', class_='sciname').text.strip()

        #Find and format image
        img = card.find('a', class_='modal_image_link small').get('href') + '/medium.jpg'
        img = img.replace('www', 'static')

        #Find and format status
        status = card.find('div', class_='occurrence description')
        if status is None: 
            status = ''
        else:
            status = status.text.split(':')[1].strip()

        birdList.append({
            "commonName": commonName, "sciName": sciName,
            "image": img, "status": status
        })

with open('iNaturalist-Data.json', 'w') as outfile:
    json.dump(birdList, outfile)
driver.quit()