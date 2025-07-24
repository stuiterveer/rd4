import QtQuick 2.7
import Lomiri.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import io.thp.pyotherside 1.4

Page {
    anchors.fill: parent

    header: PageHeader {
        id: header
        title: i18n.tr('Instellingen')
    }

    Column {
        anchors {
            top: header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        TextField {
            id: postalcode
            placeholderText: '1234 AB'

            validator: RegExpValidator {
                regExp: /^\d{4} *[a-zA-Z]{2}$/
            }

            height: units.gu(4)
            width: parent.width / 4
        }

        TextField {
            id: housenumber
            placeholderText: '1'

            inputMethodHints: Qt.ImhDigitsOnly
            validator: IntValidator {
                bottom: 1
            }

            height: units.gu(4)
            width: parent.width / 8
        }

        TextField {
            id: numberextension
            placeholderText: 'A'

            height: units.gu(4)
            width: parent.width / 8
        }

        Button {
            id: saveSettings
            text: i18n.tr('Opslaan')

            height: units.gu(4)
            width: parent.width / 2

            onClicked: {
                python.call('rd4.saveAddress', [postalcode.text, housenumber.text, numberextension.text])
                address['postalCode'] = postalcode.text
                address['number'] = housenumber.text
                address['extension'] = numberextension.text
            }
        }
    }

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../src/'));

            importModule('rd4', function() {
                console.log('module rd4 imported');
            });

            importModule('confighandler', function() {
                console.log('module confighandler imported');
            });

            python.call('confighandler.initConfig')

            python.call('confighandler.readConfig', [], function(returnValue) {
                postalcode.text = address['postalCode']
                housenumber.text = address['number']
                numberextension.text = address['extension']
            })
        }

        onError: {
            console.log('python error: ' + traceback);
        }
    }
}
