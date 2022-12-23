import pandas as pd
import streamlit as st
from database import *


def remove_food(food_id):

    selected_food = st.selectbox("Food item to delete", food_id)
    st.warning("Do you want to delete Food :{}?".format(selected_food))
    
    if st.button("Delete Food"):
        delete_food(selected_food)
        st.success("Food Item has been deleted successfully")
    