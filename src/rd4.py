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

import urllib.request
import urllib.error
import json
import confighandler
from datetime import date

config = confighandler.readConfig()

def getCalendar():
    params = '?postal_code=' + config['postalCode']
    params += '&house_number=' + config['houseNumber']
    if config['extension'] is not None:
        params += '&house_number_extension=' + config['extension']
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

    try:
        conn = urllib.request.urlopen(url)
    except urllib.error.HTTPError as err:
        return []
    returnData = conn.read()
    conn.close()

    data = json.loads(returnData)['data']['items'][0]

    i = len(data) - 1
    today = date.today()
    while i >= 0:
        dateArr = data[i]['date'].split('-')
        collectionDate = date(int(dateArr[0]), int(dateArr[1]), int(dateArr[2]))

        if collectionDate < today:
            data[i]['dateInfo'] = 'past'
        elif collectionDate == today:
            data[i]['dateInfo'] = 'today'
        elif collectionDate > today:
            data[i]['dateInfo'] = 'future'

        data[i]['types'] = []
        data[i]['types'].append(data[i]['type'])

        if i != len(data) - 1:
            if data[i]['date'] == data[i+1]['date']:
                data[i]['types'].append(data[i+1]['type'])
                del data[i+1]
        i -= 1

    return data

def saveAddress(postalCode, houseNumber, extension):
    config['postalCode'] = postalCode
    config['houseNumber'] = houseNumber
    if extension == '':
        config['extension'] = None
    else:
        config['extension'] = extension
    confighandler.writeConfig(config)

    calendar = getCalendar()
    return calendar
