import pickle
from pathlib import Path

import streamlit_authenticator as stauth

import mysql.connector

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="food_ecommerce"
)
c = mydb.cursor()

c.execute("""SELECT customer_name, customer_password FROM customer
                """)
data = c.fetchall()
c.execute("""SELECT restaurant_id, restaurant_password FROM restaurant
            """)
data_res = c.fetchall()
names = []
usernames = []
passwords = []
for i in data:
    names.append("user")
    usernames.append(i[0])
    passwords.append(i[1])

for i in data_res:
    names.append("res")
    usernames.append(i[0])
    passwords.append(i[1])
    
hashed_passwords = stauth.Hasher(passwords).generate()
file_path = Path(__file__).parent / "hashed_pw.pkl"
with file_path.open("wb") as file:
    pickle.dump(hashed_passwords, file)