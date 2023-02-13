import pandas as pd
import numpy as np

def drop_columns(df):

    """ The function drops not needed columns"""

    df = df.drop(['menu_item','book_table', 'online_order','dish_liked', 'reviews_list', 'listed_in(city)','listed_in(type)'], axis=1, inplace = True)

    