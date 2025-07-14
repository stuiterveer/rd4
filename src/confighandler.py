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

import json
import os

appId = os.environ.get('APP_ID', '').split('_')[0]
confDir = os.environ.get('XDG_CONFIG_HOME', '/tmp') + '/' + appId
confFile = confDir + '/config.json'

def writeConfig(config):
    with open(confFile, 'w') as file:
        file.write(json.dumps(config, indent=4))

def readConfig():
    with open(confFile, 'r') as file:
        config = json.load(file)
    return config

def initConfig():
    defaultConfig = {
        'postalCode': None,
        'houseNumber': None,
        'extension': None
    }

    if not os.path.exists(confDir):
        os.makedirs(confDir)

    if not os.path.exists(confFile):
        writeConfig(defaultConfig)