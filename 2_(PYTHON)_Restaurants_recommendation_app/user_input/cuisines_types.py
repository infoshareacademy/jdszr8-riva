import pandas as pd

# Type of cuisines:
def cuisines_list(df):
       
    global dict_of_cuisines
    dict_of_cuisines = {}
    for x in df.index:
        for y in df.loc[x,"cuisines"]:
            if y not in dict_of_cuisines.keys():
                dict_of_cuisines[y] = 1
            else:
                dict_of_cuisines[y] += 1
    dict_of_cuisines = dict(sorted(dict_of_cuisines.items(), key=lambda item: item[1], reverse=True))
    return dict_of_cuisines
	
cuisines_list(df)
dict_of_cuisines
