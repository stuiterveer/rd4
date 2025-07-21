/*
 * Copyright (C) 2025  stuiterveer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * rd4 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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

    TextField {
        id: postalcode
        anchors {
            top: header.bottom
            left: parent.left
        }
        placeholderText: '1234 AB'

        height: units.gu(4)
        width: parent.width / 4
    }

    TextField {
        id: housenumber
        anchors {
            top: postalcode.bottom
            left: parent.left
        }
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
        anchors {
            top: housenumber.bottom
            left: parent.left
        }
        placeholderText: 'A'

        height: units.gu(4)
        width: parent.width / 8
    }

    Button {
        id: saveSettings
        anchors {
            top: numberextension.bottom
            left: parent.left
        }
        text: i18n.tr('Opslaan')

        height: units.gu(4)
        width: parent.width / 2

        onClicked: {
            python.call('rd4.saveAddress', [postalcode.text, housenumber.text, numberextension.text])
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
                postalcode.text = returnValue['postalCode']
                housenumber.text = returnValue['houseNumber']
                numberextension.text = returnValue['extension']
            })
        }

        onError: {
            console.log('python error: ' + traceback);
        }
    }
}
