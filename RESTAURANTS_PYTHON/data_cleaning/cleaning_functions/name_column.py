from multiprocessing.managers import Namespace


def clean_name_column(df):

    """The function takes dataframe as an argument and return dataframe.
    This function clean name column. It strips phone
    It uses regex pattern"""

    names = df['name'].replace(
        ['Ã.*©', '.*©', 'Ã.*¨', 'Ã.*±', 'Ã.*¢', 'Ã.*°',
            'Ã.*»', 'Ã.*ª', 'Ã.*'],
        ['é', 'é', 'é', 'ñ', 'â', '°', 'û', 'e', '’'],
        regex=True)
    df = df.update(names)


