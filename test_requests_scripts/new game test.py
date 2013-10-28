import requests
import json
from requests.auth import HTTPBasicAuth

s = requests.session()
payload = {'email':'a@a.a', 'password':'a'} 
s.post("http://localhost:3000/sessions", data=payload)

payload = {'game[dayNightFreq]':'1','game[kill_radius]':'7', 'game[scent_radius]':'10'}
print("try without http authenticated")
r = s.get("http://intense-lake-6059.herokuapp.com/start_game/1/7.json")
print (r.text)
print (r.url)
print ("with auth")
r = s.get("http://intense-lake-6059.herokuapp.com/start_game/1/7.json", auth=('admin', 'password'))
print (r.text)
print (r.url)
r = s.get("http://intense-lake-6059.herokuapp.com/games.json", auth=('admin', 'password'))
print (r.text)
print (r.url)
r = s.get("http://intense-lake-6059.herokuapp.com/players_alive.json")
print (r.json())
print (r.url)
print (r.json()["a"])

