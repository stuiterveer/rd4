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
        title: 'Rd4'
    }

    Component {
        id: pageDelegate
        ListItem {
            Label {
                anchors.centerIn: parent
                text: name
            }
            onClicked: {
                pageStack.push(Qt.resolvedUrl(file))
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
            id: pageModel
        }
        delegate: pageDelegate

        Component.onCompleted: {
            pageModel.clear()

            var pages = [
                {
                    'name': i18n.tr('Afvalkalender'),
                    'file': 'Calendar.qml'
                },
                {
                    'name': i18n.tr('Afvalcontainers'),
                    'file': 'Containers.qml'
                },
                {
                    'name': i18n.tr('Instellingen'),
                    'file': 'Settings.qml'
                }
            ]

            for (var i = 0; i < pages.length; i++)
            {
                pageModel.append(pages[i])
            }
        }
    }
}
