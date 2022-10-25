def clean_phone_column(df):
    """The function takes dataframe as an argument and return dataframe.
    This function clean phone column. It strips phone
    number form unrelevant symbols and concat phone numbers
    """

    phone_numbers = df['phone'].str.split(
        pat="""\n""", n=2, expand=True)

    phone_numbers.rename(columns={0: 'phone1', 1: 'phone2'}, inplace=True)

    phone_numbers[['phone1', 'phone2']].astype(str)

    phone_numbers['phone1'] = phone_numbers['phone1'].str.replace(
        '\W', '', regex=True)

    phone_numbers['phone2'] = phone_numbers['phone2'].str.replace(
        '\W', '', regex=True)

    df['phone1'] = phone_numbers['phone1']

    df['phone2'] = phone_numbers['phone2']

    df['phone1'].replace(
        to_replace=[None], value='No number', inplace=True)

    df['phone2'].replace(
        to_replace=[None], value='No number', inplace=True)

    df['phone'] = (
        df['phone1'] + ', ' + df['phone2'])

    df = df.drop(columns=['phone1', 'phone2'])

    df['phone'].replace(
        to_replace=', No number', value='', inplace=True, regex=True)

    df['phone'].str.strip()

    return df
