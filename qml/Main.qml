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

    PageStack {
        id: pageStack
        anchors.fill: parent

        Component.onCompleted: {
            pageStack.push(Qt.resolvedUrl("Calendar.qml"))
        }
    }
}
