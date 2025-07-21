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
        title: i18n.tr('Afvalkalender')
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
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        
        model: ListModel {
            id: wasteModel
        }
        delegate: wasteDelegate
    }

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../src/'));

            importModule('rd4', function() {
                console.log('module rd4 imported');
            });

            python.call('rd4.getCalendar', [], function(returnValue) {
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

        onError: {
            console.log('python error: ' + traceback);
        }
    }
}
