# import pandas as pd
# import streamlit as st
# import plotly.express as px
# from database import *


# def read_res_menu(resname):
#     print(resname)
#     result = view_res_menu(resname)
#     df = pd.DataFrame(result, columns=['food_id', 'food_name', 'category', 'serves', 'cost', 'stock', 'restaurant_id'])
#     st.dataframe(df)
#     return df['food_id'].tolist()



# def read_menu():
#     result = view_all_menu()
#     df = pd.DataFrame(result, columns=['Food ID', 'Food Name', 'Categroy', 'Serves', 'Cost', 'Restaurant Name'])
#     st.dataframe(df)

# def read_cart(username):
#     cart_id = get_cart_from_name(username)
#     result = view_user_cart(cart_id[0][0])
#     df = pd.DataFrame(result, columns=['Name', 'Quantity', 'Total Cost'])
#     cart_total = df.sum(axis = 0, skipna = True)['Total Cost']
    
#     st.dataframe(df)
#     st.text(f"Cart Total: ₹{cart_total}")  

    
#     data = get_coupon(cart_id[0][0])

#     if(data):

#         coupon_code = data[0][0]
#         discount = data[0][1]

#         st.text(f"Coupon Applied on this Cart: {coupon_code}")
#         st.text(f"Discount availed from this Coupon: {discount}")

#         total = cart_total - (discount/100)*cart_total
    
#     else:
#         total = cart_total

#     st.success(f"Cart Total: ₹{total}")

#     return total

import pandas as pd
import streamlit as st
import plotly.express as px
from database import *


def read_res_menu(resname):
    print(resname)
    result = view_res_menu(resname)
    df = pd.DataFrame(result, columns=['food_id', 'food_name', 'category', 'serves', 'cost', 'stock', 'restaurant_id'])
    st.dataframe(df)
    return df['food_id'].tolist()



def read_menu():
    result = view_all_menu()
    df = pd.DataFrame(result, columns=['Food ID', 'Food Name', 'Categroy', 'Serves', 'Cost', 'Restaurant Name'])
    st.dataframe(df)

def read_cart(username):
    cart_id = get_cart_from_name(username)
    result = view_user_cart(cart_id[0][0])
    df = pd.DataFrame(result, columns=['Name', 'Quantity', 'Total Cost'])
    cart_total = df.sum(axis = 0, skipna = True)['Total Cost']
    
    st.dataframe(df)
    st.text(f"Cart Total: ₹{cart_total}")  

    
    data = get_coupon(cart_id[0][0])

    if(data == []):
        coupons = get_all_coupons()
        coupons_df = pd.DataFrame(coupons, columns=['coupon_code', 'discount'])
        with st.expander("View Coupons"):
            st.dataframe(coupons_df)
        selected_coupon = st.selectbox("Select a coupon: ", coupons_df['coupon_code'].tolist())
        if st.button("Apply Coupon"):
            update_cart(selected_coupon, cart_id[0][0])
            st.success("Applied")

    if(data):

        coupon_code = data[0][0]
        discount = data[0][1]

        st.text(f"Coupon Applied on this Cart: {coupon_code}")
        st.text(f"Discount availed from this Coupon: {discount}")

        total = cart_total - (discount/100)*cart_total
    
    else:
        total = cart_total

    st.success(f"Cart Total: ₹{total}")

    return total

