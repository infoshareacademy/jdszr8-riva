import pandas as pd
import numpy as np

def clean_cuisine_column(df):

	""" The function converts the data type of a column containing types of cuisine served in a restaurant. 
    It takes a data frame as an argument and converts the column values: from a string to a list of strings."""

	for x in df.index:
		if df.loc[x, "cuisines"] is not np.nan:
			initial_list = str(df.loc[x, "cuisines"]).split(",")
			list_to_insert=[]
			for y in initial_list:
				list_to_insert.append(y.strip())
			df.at[x, "cuisines"] = list_to_insert
    
    