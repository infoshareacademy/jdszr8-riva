import pandas as pd
import numpy as np

def clean_rates(df):

    """ The function converts the data type of a column containing rates of each restaurant. 
    It takes a data frame as an argument and converts data to integer."""

    df['rate'] = df['rate'].replace(['NEW','-'], [np.nan, np.nan])
    df['rate'] = df['rate'].str.split('/').str[0]
    df['rate'] = df['rate'].str.strip()
    df['rate'] = df['rate'].astype(float)
    