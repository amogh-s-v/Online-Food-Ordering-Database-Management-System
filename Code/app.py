import streamlit as st
from create import *
from delete import *
from read import *
from database import *
from update import *
import pandas as pd
# from update import update



import pickle
from pathlib import Path

import streamlit_authenticator as stauth

data, data_res = get_names_passwords()
names = []
usernames = []

for i in data:
    names.append("users")
    usernames.append(i[0])
for i in data_res:
    names.append("res")
    usernames.append(i[0])

file_path = Path(__file__).parent / "hashed_pw.pkl"
with file_path.open("rb") as file:
    hashed_passwords = pickle.load(file)

authenticator = stauth.Authenticate(names, usernames, hashed_passwords,
    "sales_dashboard", "abcdef", cookie_expiry_days=30)

name, authentication_status, username = authenticator.login("Login", "main")


if authentication_status == False:
    st.error("Username/password is incorrect")

    with st.expander("Register"):
        col1, col2 = st.columns(2)
    
        with col1:
            customer_id = st.text_input("Customer ID:")
            customer_name = st.text_input("Username:")
            customer_password = st.text_input("Password:")
            customer_address = st.text_input("Address")
    
        with col2:
            pincode = st.text_input("Pincode:")
            phone_no = st.text_input("Phone Number: ")
            cart_id = st.text_input("Cart ID: ")
    
        if st.button("Register"):
            add_new_user(customer_id, customer_password, customer_name, customer_address, pincode, phone_no, cart_id)
            st.success("Successfully added User")
            generate_keys()

if authentication_status == None:
    st.warning("Please enter your username and password")
    
    with st.expander("Register"):
        col1, col2 = st.columns(2)
    
        with col1:
            # customer_id = st.text_input("Customer ID:")
            customer_name = st.text_input("Username:")
            customer_password = st.text_input("Password:")
            customer_address = st.text_input("Address")
    
        with col2:
            pincode = st.text_input("Pincode:")
            phone_no = st.text_input("Phone Number: ")
    
        if st.button("Register"):
            add_new_user(customer_password, customer_name, customer_address, pincode, phone_no)
            st.success("Successfully added User")
            generate_keys()



if authentication_status:

    authenticator.logout("Logout", "sidebar")

    st.title("Food Ordering System")

    menu_user = ["View and Add From Menu (Customer)", "Manage Cart (Customer)", "SQL Query Box" ]

    menu_res = ["Add Food Items (Restaurant)", "Edit Menu (Restaurant)", "Remove Items (Restaurant)"]

    

    if name == "res":

        st.sidebar.header(username)

        choice_res = st.sidebar.selectbox("Restaurant", menu_res)
        if choice_res == "Add Food Items (Restaurant)":
            st.subheader("Enter Food Details Details:")
            create_food_items(username)

        if choice_res == "Edit Menu (Restaurant)":
            st.subheader("Your Menu:")
            food_id = read_res_menu(username)
            modfiy_menu(username, food_id)
        
        if choice_res == "Remove Items (Restaurant)":
            st.subheader("Your Menu:")
            food_id = read_res_menu(username)
            remove_food(food_id)


    elif name == "users":

        st.sidebar.header(username)

        choice_user = st.sidebar.selectbox("User", menu_user)
        
        if choice_user == "View and Add From Menu (Customer)":
            st.subheader("Menu:")
            read_menu()
            st.subheader("Add to Cart")
            create_cart_items(username)
    
        if choice_user == "Manage Cart (Customer)":
            st.subheader("Your Cart")
            total = read_cart(username)
            with st.expander("Make Payment"):
                payment_type = st.selectbox("Payment Methods:", ["GPay", "PhonePe", "Card"])
                create_payment(username, total, payment_type)

        if choice_user == "SQL Query Box":
            sqlq = st.text_area("Enter your SQL Query")
            if st.button("Execute"):
                try:
                    c.execute(sqlq)
                    st.dataframe(pd.DataFrame(c.fetchall()))
                except mysql.connector.errors.InterfaceError:
                    st.warning("No Output")
                except Exception as e:
                    st.error(e)
    

