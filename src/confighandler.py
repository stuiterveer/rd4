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