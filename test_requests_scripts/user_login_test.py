import requests
import json
print ("testing werewolf app")

print ("login test---should fail without signing in")

r = requests.get('http://intense-lake-6059.herokuapp.com/users')

if r.url == "http://intense-lake-6059.herokuapp.com/log_in":
    print ("redirection successful")
else:
    print ("redirection unsuccessful")

print()

print("create user")
payload = {'user[email]':'x@x.x', 'user[password]':'x', 'user[password_confirmation]':'x'}  #USE NEW INFO TO TEST
r= requests.post("http://intense-lake-6059.herokuapp.com/users.json", data = payload)
print (r.text)
print (r.url)

print ("log in")

payload = {'email':'x@x.x', 'password':'x'} 
s = requests.session()
s.post("http://intense-lake-6059.herokuapp.com/sessions", data=payload) #WORKS TO LOG IN
r2 = s.get("http://intense-lake-6059.herokuapp.com/leaderboard.json")
print (r2.text)
print (r2.url)




