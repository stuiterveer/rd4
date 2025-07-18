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

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'rd4.stuiterveer'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    readonly property var trashLut: {
        'residual_waste': i18n.tr('Restafval'),
        'gft': i18n.tr('GFT'),
        'paper': i18n.tr('Papier'),
        'pruning_waste': i18n.tr('Snoeiafval'),
        'pmd': i18n.tr('PMD'),
        'best_bag': i18n.tr('BEST-tas'),
        'christmas_trees': i18n.tr('Kerstbomen')
    }

    readonly property bool isDark: theme.name === 'Lomiri.Components.Themes.SuruDark'

    Page {
        anchors.fill: parent

        header: PageHeader {
            id: header
            title: i18n.tr('Rd4 Afvalkalender')
        }

        Component {
            id: wasteDelegate
            Item {
                height: txt.implicitHeight
                width: txt.implicitWidth

                Row {
                    Text {
                        id: txt
                        text: '<b>' + date + (dateInfo == 'today' ? ' (' + i18n.tr('vandaag') + ')' : '') + ':</b> ' + typesString
                        color: dateInfo == 'past' ? '#888888' : (isDark ? '#ffffff' : '#111111')
                    }
                }
            }
        }


        ListView {
            anchors {
                top: postalcode.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            
            model: ListModel {
                id: wasteModel
            }
            delegate: wasteDelegate
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
                top: header.bottom
                left: postalcode.right
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
                top: header.bottom
                left: housenumber.right
            }
            placeholderText: 'A'

            height: units.gu(4)
            width: parent.width / 8
        }

        Button {
            id: showcalendar
            anchors {
                top: header.bottom
                left: numberextension.right
            }
            text: i18n.tr('Toon kalender')

            height: units.gu(4)
            width: parent.width / 2

            onClicked: {
                python.call('rd4.saveAddress', [postalcode.text, housenumber.text, numberextension.text], function(returnValue) {
                    wasteModel.clear()
                    for (var i = 0; i < returnValue.length; i++)
                    {
                        var typesTrans = []
                        for (var j = 0; j < returnValue[i]['types'].length; j++)
                        {
                            typesTrans.push(trashLut[returnValue[i]['types'][j]])
                        }
                        returnValue[i]['typesString'] = typesTrans.join(', ')
                        wasteModel.append(returnValue[i])
                    }
                })
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
