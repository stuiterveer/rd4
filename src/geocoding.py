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

config = confighandler.readConfig()

def postalToGeo():
    params = '?country=nl'
    params += '&postalcode=' + config['postalCode']
    params += '&format=geojson'

    url = 'https://nominatim.openstreetmap.org/search{}'.format(params)
    url = url.replace(" ", "%20")

    try:
        conn = urllib.request.urlopen(url)
    except urllib.error.HTTPError as err:
        return []
    returnData = conn.read()
    conn.close()

    return json.loads(returnData)['features'][0]
