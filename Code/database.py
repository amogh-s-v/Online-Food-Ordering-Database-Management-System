# pip install mysql-connector-python
import mysql.connector
import datetime
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

def execute_query(query):
    try:
        c.execute(query)
        return "Success", c.fetchall()
    except Exception as e:
        return e

def get_names_passwords():
    c.execute("""SELECT customer_name, customer_password FROM customer
                """)
    data = c.fetchall()
    c.execute("""SELECT restaurant_id, restaurant_password FROM restaurant
                """)
    data_res = c.fetchall()
    return data, data_res

def add_new_user(customer_password, customer_name, customer_address, pincode, phone_no):
    c.execute(f"""SELECT customer_id FROM customer""")
    exisiting_users = c.fetchall()
    ids = []
    for i in range(len(exisiting_users)):
            id = int(exisiting_users[i][0][3:])
            ids.append(id)
    id_ = max(ids)+1
    customer_id = "CUS00"+str(id_)
    cart_id = customer_id.replace('US',"")
    print(customer_id, cart_id)
    c.execute(f"""INSERT INTO customer VALUES('{customer_id}', '{customer_password}', '{customer_name}', '{customer_address}', '{pincode}', '{phone_no}', '{cart_id}')""")
    mydb.commit()

def add_to_food_items(food_id, food_name, category, serves, cost, stock, restaurant_id):
    c.execute(f"""INSERT INTO food_items VALUES('{food_id}', '{food_name}', '{category}', '{serves}', {cost}, {stock}, '{restaurant_id}')""")
    mydb.commit()

def generate_keys():
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
        names.append("user")
        usernames.append(i[0])
        passwords.append(i[1])
        
    hashed_passwords = stauth.Hasher(passwords).generate()

    file_path = Path(__file__).parent / "hashed_pw.pkl"
    with file_path.open("wb") as file:
        pickle.dump(hashed_passwords, file)


def get_coupon(cart_id):
    c.execute(f"""
    SELECT coupon.coupon_code, coupon.discount
    FROM cart NATURAL JOIN coupon
    WHERE cart.cart_id = '{cart_id}';
    """)
    return c.fetchall()

def get_all_coupons():
    c.execute(f"""SELECT * FROM coupon""")
    return c.fetchall()

def get_cart_from_name(username):
    c.execute(f"""
    SELECT cart_id FROM customer WHERE customer_name = '{username}'
    """)
    data = c.fetchall()
    return data

def view_all_menu():
    c.execute("""SELECT food_id, food_name, category, serves, cost, restaurant_name 
                 FROM food_items JOIN restaurant 
                 ON food_items.restaurant_id = restaurant.restaurant_id
                """)
    data = c.fetchall()
    return data

def add_to_cart_items(cart_id, food_id, quantity):
    data_added = datetime.date.today()
    c.execute(f"""INSERT INTO cart_items VALUES({quantity}, '{data_added}', '{cart_id}', '{food_id}')""")
    mydb.commit()

def view_user_cart(cart_id):
    c.execute(f"""SELECT  f.food_name as Name, c.quantity_chosen as Quantity, f.cost*c.quantity_chosen as Cost
                FROM cart_items as c JOIN food_items as f
                ON c.food_id = f.food_id
                WHERE c.cart_id = '{cart_id}';
                """)
    data = c.fetchall()
    return data

def update_cart(coupon_code, cart_id):
    c.execute(f"""UPDATE cart SET coupon_code = '{coupon_code}' WHERE cart_id = '{cart_id}'""")
    mydb.commit()

def make_payment(payment_id, payment_type, customer_id, cart_id, amount):
    payment_date = datetime.date.today()
    c.execute(f"""INSERT INTO payment VALUES ('{payment_id}', '{payment_date}', '{payment_type}', '{customer_id}', '{cart_id}', {amount})""")
    mydb.commit()

def get_payment_list():
    c.execute(f"""SELECT payment_id FROM payment""")
    return c.fetchall()
#############################################################

def view_res_menu(resname):
    c.execute(f"""SELECT * FROM food_items WHERE food_items.restaurant_id = '{resname}'""")
    data = c.fetchall()
    return data

def get_food(food_id):
    c.execute(f"""SELECT * FROM food_items WHERE food_id = '{food_id}'""")
    data = c.fetchall()
    return data

def edit_food_data(food_id, food_name, category, serves, cost, stock, resname):
    print(food_id, food_name, category, serves, cost, stock, resname)
    c.execute(f"""UPDATE food_items SET food_name = '{food_name}', category = '{category}', serves = {serves}, cost = {cost}, stock = {stock} WHERE food_id = '{food_id}'""")
    mydb.commit()

def delete_food(food_id):
    print(food_id)
    c.execute(f""" DELETE FROM food_items WHERE food_id = '{food_id}'""")
    mydb.commit()

