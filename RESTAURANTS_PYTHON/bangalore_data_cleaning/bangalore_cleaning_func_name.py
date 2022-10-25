def names_cleaning(bangalore_data):
    """This function clean name column. It strips phone
    It uses regex pattern"""

    names = bangalore_data['name'].replace(
        ['Ã.*©', '.*©', 'Ã.*¨', 'Ã.*±', 'Ã.*¢', 'Ã.*°',
            'Ã.*»', 'Ã.*ª', 'Ã.*'],
        ['é', 'é', 'é', 'ñ', 'â', '°', 'û', 'e', '’'],
        regex=True)
    bangalore_data.update(names)

    return bangalore_data
