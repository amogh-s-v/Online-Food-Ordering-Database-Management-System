import datetime

import pandas as pd
import streamlit as st
from database import *


def modfiy_menu(resname, food_id):

    selected_food = st.selectbox("Food item to edit", food_id)
    selected_result = get_food(selected_food)
    if selected_result:
        food_name = selected_result[0][1]
        category = selected_result[0][2]
        serves = selected_result[0][3]
        price = selected_result[0][4]
        stock = selected_result[0][5]

        # Layout of Create

        col1, col2 = st.columns(2)
        with col1:
            new_food_name = st.text_input("Food Name:", food_name)
            new_category = st.text_input("Category:", category)
        with col2:
            new_serves = st.number_input("Serves", serves)
            new_cost = st.number_input("Price:", price)
        new_stock = st.number_input("Stock:", min_value=stock-10, max_value=stock+30)
        if st.button("Update Food Item"):
            edit_food_data(selected_food, new_food_name, new_category, new_serves, new_cost, new_stock, resname)
            st.success("Successfully updated")



