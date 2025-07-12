'''
 Copyright (C) 2025  stuiterveer

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; version 3.

 rd4 is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
'''

from urllib import request
import json


addressDetails = {
    'postalCode': None,
    'houseNumber': None,
    'extension': None,
}

def getCalendar():
    params = '?postal_code=' + addressDetails['postalCode']
    params += '&house_number=' + addressDetails['houseNumber']
    if addressDetails['extension'] is not None:
        params += '&house_number_extension=' + addressDetails['extension']
    params += '&year=2025'
    params += '&types[]=residual_waste'
    params += '&types[]=gft'
    params += '&types[]=paper'
    params += '&types[]=pruning_waste'
    params += '&types[]=pmd'
    params += '&types[]=best_bag'
    params += '&types[]=christmas_trees'

    url = 'https://data.rd4.nl/api/v1/waste-calendar{}'.format(params)
    url = url.replace(" ", "%20")

    conn = request.urlopen(url)
    returnData = conn.read()
    conn.close()

    data = json.loads(returnData)['data']['items'][0]

    return data

def saveAddress(postalCode, houseNumber, extension):
    addressDetails['postalCode'] = postalCode
    addressDetails['houseNumber'] = houseNumber
    if extension == '':
        addressDetails['extension'] = None
    else:
        addressDetails['extension'] = extension
    calendar = getCalendar()
    return calendar

