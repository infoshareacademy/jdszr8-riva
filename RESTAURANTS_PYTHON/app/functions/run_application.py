import pandas as pd
from .functions_to_import import *

def run_application(preferences,df:pd.DataFrame):

    filtered_data = filter_data(preferences,df)
    user_location=generate_user_location(filtered_data)
    data_with_distance=calculate_distance_and_walk_time(filtered_data, user_location)
    normalized_data=normalize_data(data_with_distance,['rate','cost','distance','votes'])
    final_data=calculate_euclidean_distance(normalized_data)
    top_10_restaurants = final_data.sort_values(by="euclidean_dist",ascending=True)[:10]
    return top_10_restaurants
    # map=generate_map(top_10_restaurants, user_location)
    # display(map)