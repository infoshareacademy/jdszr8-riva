import random
from  geopy import distance
from scipy.spatial import distance as scipy_distance
import pandas as pd
import numpy as np
import ipywidgets as widgets
from IPython.display import display
import numpy as np
from .run_application import run_application

# Types of cuisines
def cuisines_list(df):
    
    global dict_of_cuisines
    dict_of_cuisines = {}
    for x in df.index:
        for y in df.loc[x,'cuisines']:
            if y not in dict_of_cuisines.keys():
                dict_of_cuisines[y] = 1
            else: 
                dict_of_cuisines[y] += 1
    dict_of_cuisines = dict(sorted(dict_of_cuisines.items(), key=lambda item: item[1], reverse = True))
    return dict_of_cuisines

def display_widgets(df):

    price_selection = widgets.SelectionRangeSlider(options=['$', '$$', '$$$','$$$$'],index=(0, 3), 
                                                    description='Price range: ',disabled=False)
    cuisine_selection = widgets.SelectMultiple(options=cuisines_list(df).keys(),
                                                description='Cuisines',disabled=False)
    rate_selection = widgets.FloatSlider(value=4,min=0,max=5,step=0.1, description='Minimum rate: ')

    button = widgets.Button(description="OK")
    
    global preferences
    preferences={}

    def collect_preferences():

        preferences["price"] = price_selection.value
        preferences["cuisine"] = cuisine_selection.value
        preferences["rate"] = rate_selection.value
        return preferences

    def display_preferences(preferences):
        print(f'Your preferences:\n -- cuisine: {preferences["cuisine"]} \n -- minimum rating: {preferences["rate"]} \n -- price: {preferences["price"]}')


    def on_button_clicked(b):

        collect_preferences()
        price_selection.close()
        cuisine_selection.close()
        rate_selection.close()
        button.close()
        display_preferences(preferences)
        run_application(preferences,df)

    display(cuisine_selection,rate_selection,price_selection, button)
    button.on_click(on_button_clicked)