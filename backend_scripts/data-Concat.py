import json

with open('eBird-Data.json') as infile:
    E_BIRD_DATA = json.load(infile)

with open('iNaturalist-Data.json') as infile:
    I_NAT_DATA = json.load(infile)

birds = []
for natBird in I_NAT_DATA:
    if natBird['commonName'] in E_BIRD_DATA:
        birds.append({
            'commonName': natBird['commonName'],
            'sciName': natBird['sciName'],
            'image': natBird['image'],
            'status': natBird['status'],
            'location':  E_BIRD_DATA[natBird['commonName']]
        })
    else:
        birds.append(natBird)

with open('Birds-Data.json', 'w') as outfile:
    json.dump(birds, outfile)