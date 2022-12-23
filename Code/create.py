import streamlit as st
from database import *


def create_food_items(restaurant_id):
    col1, col2 = st.columns(2)
    with col1:
        food_id = st.text_input("Food ID:")
        food_name = st.text_input("Food Name:")
        category  = st.text_input("Category: ")
    
    with col2:
        serves = st.number_input("Serves:", min_value=1, max_value=5, step=1)
        cost = st.number_input("Cost:", step=1)
        stock = st.number_input("Stock:", min_value=1, max_value=100, step=1)
        
    
    if st.button("Add Food Item"):
        add_to_food_items(food_id, food_name, category, serves, cost, stock, restaurant_id)
        st.success("Successfully added Food: {}".format(food_name))

def create_cart_items(username):
    food_id = st.text_input("Enter the Food ID: ")
    # cart_id = customer_id.replace('US',"")
    cart_id = get_cart_from_name(username)
    cart_id = cart_id[0][0]
    quantity = st.number_input("Quantity:", min_value=1, max_value=5, step=1)
    if st.button("Add to Cart"):
        add_to_cart_items(cart_id, food_id, quantity)
        st.success("Successfully added Food: {} to Cart: {}".format(food_id, cart_id))

def create_payment(username, amount, payment_type):
    cart_id = get_cart_from_name(username)
    cart_id = cart_id[0][0]
    customer_id = cart_id[:1]+"US"+cart_id[1:]
    payment_id = cart_id.replace('C', 'P')
    exisiting_payments = get_payment_list()
    ids = []
    if payment_id in [i[0] for i in exisiting_payments]:
        for i in range(len(exisiting_payments)):
            id = int(exisiting_payments[i][0][0:0] + exisiting_payments[i][0][0+1:])
            ids.append(id)
        id_ = max(ids)+1
        payment_id = "P00"+str(id_)    
        
    if st.button("Confirm Payment"):
        make_payment(payment_id, payment_type, customer_id, cart_id, amount)
        st.success("Payment of: {} Successfully made for Cart: {} with Payment ID: {}".format(amount, cart_id, payment_id))
        st.balloons()
