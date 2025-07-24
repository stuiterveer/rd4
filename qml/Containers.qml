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
        title: i18n.tr('Afvalcontainers')
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
                source: imageFile
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

        gesture.enabled: true
        gesture.acceptedGestures: MapGestureArea.PinchGesture | MapGestureArea.PanGesture | MapGestureArea.FlickGesture

        center {
            latitude: 50.853577
            longitude: 5.871849
        }
        minimumZoomLevel: 12

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

            importModule('geocoding', function() {
                console.log('module geocoding imported');
            });

            containerModel.clear()

            if (address['postalCode']) {
                python.call('geocoding.postalToGeo', [], function(returnValue) {
                    map.center.latitude = returnValue['geometry']['coordinates'][1]
                    map.center.longitude = returnValue['geometry']['coordinates'][0]
                    map.zoomLevel = 18

                    containerModel.append({
                        'x_coordinate': returnValue['geometry']['coordinates'][0].toString(),
                        'y_coordinate': returnValue['geometry']['coordinates'][1].toString(),
                        'imageFile': '../assets/marker_blue.png'
                    })
                })
            }

            python.call('rd4.getLocations', [], function(returnValue) {
                for (var i = 0; i < returnValue.length; i++)
                {
                    returnValue[i]['imageFile'] = '../assets/marker_red.png'
                    containerModel.append(returnValue[i])
                }
            })
        }

        onError: {
            console.log('python error: ' + traceback);
        }
    }
}
