import requests
# url removed due to data security
url = 'insert_url_here'
files = {'file': open('file.txt', 'rb')}

response = requests.post(url, files=files)

print(response.text)