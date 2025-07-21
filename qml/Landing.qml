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

    Column {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        ListItem {
            Label {
                anchors.centerIn: parent
                text: i18n.tr('Afvalkalender')
            }
            onClicked: {
                pageStack.push(Qt.resolvedUrl('Calendar.qml'))
            }
        }

        ListItem {
            Label {
                anchors.centerIn: parent
                text: i18n.tr('Afvalcontainers')
            }
            onClicked: {
                pageStack.push(Qt.resolvedUrl('Containers.qml'))
            }
        }

        ListItem {
            Label {
                anchors.centerIn: parent
                text: i18n.tr('Instellingen')
            }
            onClicked: {
                pageStack.push(Qt.resolvedUrl('Settings.qml'))
            }
        }
    }
    
}
