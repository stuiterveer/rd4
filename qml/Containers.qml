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
import QtLocation 5.12
import QtPositioning 5.12

Page {
    anchors.fill: parent

    header: PageHeader {
        id: header
        title: 'Afvalcontainers'
    }

    Plugin {
        id: osmMapPlugin
        name: "osm"
        PluginParameter {
            name: "useragent"
            value: "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
        }
        PluginParameter {
            name: "osm.mapping.custom.host"
            value: "https://tile.openstreetmap.org/"
        }
    }

    ListModel {
        id: containerModel
    }

    Component {
        id: pointDelegate

        MapQuickItem {
            coordinate: QtPositioning.coordinate(y_coordinate, x_coordinate)

            anchorPoint.x: image.width * 0.5
            anchorPoint.y: image.height

            sourceItem: Image {
                id: image
                source: '../assets/marker_red.png'
            }
        }
    }

    Map {
        id: map

        anchors {
            top: header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        plugin: osmMapPlugin
        activeMapType: supportedMapTypes[supportedMapTypes.length - 1]

        center {
            latitude: 50.853577
            longitude: 5.871849
        }
        minimumZoomLevel: 12

        minimumTilt: 0
        maximumTilt: 0

        MapItemView {
            model: containerModel
            delegate: pointDelegate
        }
    }

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../src/'));

            importModule('rd4', function() {
                console.log('module rd4 imported');
            });

            python.call('rd4.getLocations', [], function(returnValue) {
                containerModel.clear()
                for (var i = 0; i < returnValue.length; i++)
                {
                    containerModel.append(returnValue[i])
                }
            })
        }

        onError: {
            console.log('python error: ' + traceback);
        }
    }
}
