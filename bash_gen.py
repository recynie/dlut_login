#!/bin/python3
import math
import requests
from retry import retry
import json

with open('info.json','r') as f:
    d=json.load(f)
ID = d['id']
PASSWORD = d['password']

TEMPLATE='dlut_login/template.sh'
TARGET=f'dlut_login/login.sh'

e = '010001'
m = '94dd2a8675fb779e6b9f7103698634cd400f27a154afa67af6166a43fc26417222a79506d34cacc7641946abda1785b7acf9910ad6a0978c91ec84d40b71d2891379af19ffb333e7517e390bd26ac312fe940c340466b4a5d4af1d65c3b5944078f96a1a51a5a53e4bc302818b7c9f63c4a1b07bd7d874cef1c3d4b2f5eb7871'
url_index = 'http://123.123.123.123/'
user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'

m = int.from_bytes(bytearray.fromhex(m), byteorder='big')
e = int.from_bytes(bytearray.fromhex(e), byteorder='big')

@retry(tries=5,delay=2)
def access_login():
    login_page_url = requests.get(url_index).text.split('\'')[1]
    query_string = login_page_url.split('?')[1]
    query_list = query_string.split('&')
    return query_list

for i in access_login():
    query_item = i.split('=')
    if query_item[0] == 'mac':
        mac = query_item[1]

print(mac)

plaintext = PASSWORD + '>' + mac
plaintext = plaintext.encode('utf-8')

input_nr = int.from_bytes(plaintext, byteorder='big')
crypted_nr = pow(input_nr, e, m)
keylength = math.ceil(m.bit_length() / 8)
crypted_data = crypted_nr.to_bytes(keylength, byteorder='big')
print(crypted_data.hex())

with open(TEMPLATE,'r') as s:
    l=s.readlines()
    l.insert(1,'passwd=\"' + str(crypted_data.hex()) + '\"\n')
    l.insert(1,'id=\"' + ID + '\"\n')
s = ''.join(l)
with open(TARGET, 'w', encoding='utf-8') as file:
    file.write(s)
