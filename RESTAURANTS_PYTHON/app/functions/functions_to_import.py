import random
from  geopy import distance
from scipy.spatial import distance as scipy_distance
import pandas as pd
import numpy as np
import ipywidgets as widgets
from IPython.display import display
import numpy as np

# Price filter:

def price_filter(preferences:dict,df:pd.DataFrame):

    # Ranges were defined based on the following analysis of the input data frame:
    q25 = df["cost"].quantile(0.25)
    q50 = df["cost"].quantile(0.5)
    q75 = df["cost"].quantile(0.75)
    max = df["cost"].max()

    p = preferences["price"]
    price_ranges={'$':(0,q25), '$$': (q25,q50), '$$$':(q50,q75), '$$$$':(q75,max)}
    price_min = float(price_ranges[p[0]][0])
    price_max = float(price_ranges[p[1]][1])
    df.query("@price_min < cost <= @price_max",inplace=True)

    return df

# Cuisine filter
def cuisines_filter(preferences:dict,df:pd.DataFrame): 
    
    p = preferences["cuisine"]
    
    df.loc[(df.apply(lambda x: any(m in str(v)
                               for v in x.values 
                               for m in p), axis=1))]
    return df

# Range filter
def range_filter(preferences:dict,df:pd.DataFrame):
    
    p = preferences["rate"]
    df.query(f'rate >= {p}', inplace=True)
    return df


def filter_data(preferences,df):
    cuisines_filter(preferences, df)
    price_filter(preferences, df)
    range_filter(preferences, df)
    
    return df


# Wywolosowanie user_location
def generate_user_location(df:pd.DataFrame):
    
        lat = random.uniform(df["latitude"].min(), df["latitude"].max())
        long = random.uniform(df["longitude"].min(), df["longitude"].max())
        global user_location
        user_location = lat, long
        return user_location

# Obliczanie odległości

def calculate_distance_and_walk_time(df, user_location):
    df_latitude_col=df["latitude"]
    df_longitude_col=df["longitude"]
    rest_location = list(zip(df_latitude_col, df_longitude_col))
    df['rest_location'] = rest_location
    df['distance'] = df['rest_location'].apply(lambda x: distance.distance(x, user_location).kilometers)
    df['walk_time_estimation'] = round(df['distance'].apply(lambda x: x * 12),0)
    return df

# Data normalization
def normalize_data (df, column_names:list):

    for column_name in column_names:
        new_name = "".join([column_name, "norm"])
        df[new_name] = 0
        x_min = df[column_name].min()
        x_max = df[column_name].max()
        for x in df[column_name].index: 
            df.at[x, new_name] = (df[column_name][x] - x_min)/(x_max-x_min)
    
    return df



# Obliczanie odległości euklidesowych - wybór optymalnych restauracji
def calculate_euclidean_distance(df):
    df_rate_col = df["ratenorm"]
    df_votes_col = df["votesnorm"]
    df_cost_col = df["costnorm"]
    df_dist_col= df["distancenorm"]
    df['rest_score'] = list(zip(df_rate_col, df_votes_col, df_cost_col, df_dist_col))
    df['euclidean_dist'] = df['rest_score'].apply(lambda rest_score_col: scipy_distance.euclidean(rest_score_col, [1, 1, 0, 0],w=[1, 0.5, 1, 3] ))
    return df