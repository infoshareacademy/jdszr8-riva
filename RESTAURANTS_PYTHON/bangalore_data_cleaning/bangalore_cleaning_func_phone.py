def phone_cleaning(bangalore_data):
    """This function clean phone column. It strips phone
    number form unrelevant symbols and concat phone numbers"""

    phone_numbers = bangalore_data['phone'].str.split(
        pat="""\n""", n=2, expand=True)

    phone_numbers.rename(columns={0: 'phone1', 1: 'phone2'}, inplace=True)

    phone_numbers[['phone1', 'phone2']].astype(str)

    phone_numbers['phone1'] = phone_numbers['phone1'].str.replace(
        '\W', '', regex=True)

    phone_numbers['phone2'] = phone_numbers['phone2'].str.replace(
        '\W', '', regex=True)

    bangalore_data['phone1'] = phone_numbers['phone1']

    bangalore_data['phone2'] = phone_numbers['phone2']

    bangalore_data['phone1'].replace(
        to_replace=[None], value='No number', inplace=True)

    bangalore_data['phone2'].replace(
        to_replace=[None], value='No number', inplace=True)

    bangalore_data['phone'] = (
        bangalore_data['phone1'] + ', ' + bangalore_data['phone2'])

    bangalore_data = bangalore_data.drop(columns=['phone1', 'phone2'])

    bangalore_data['phone'].replace(
        to_replace=', No number', value='', inplace=True, regex=True)

    bangalore_data['phone'].str.strip()

    return bangalore_data
