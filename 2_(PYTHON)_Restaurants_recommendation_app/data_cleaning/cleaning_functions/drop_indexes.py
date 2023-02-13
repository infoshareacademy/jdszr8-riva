import pandas as pd
import numpy as np

def drop_empty_rows(df):

	""" The function drops empty index where cuisines and location value is null"""

	df.dropna(subset=['cuisines'], inplace=True)
	df.dropna(subset=['location'], inplace=True)
