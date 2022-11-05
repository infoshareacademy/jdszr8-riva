def drop_duplicated_rows(df):

    """ The function drops not duplicated rows"""

    df = df.drop_duplicates(subset=["address", "rest_type"], inplace=True)
