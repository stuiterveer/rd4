import QtQuick 2.7
import Lomiri.Components 1.3
import io.thp.pyotherside 1.4
import QtLocation 5.12
import QtPositioning 5.12

Page {
    anchors.fill: parent

    header: PageHeader {
        id: header
        title: containerInfo['name']
    }

    ListItem {
        id: address
        anchors {
            top: header.bottom
        }
        Label {
            text: containerInfo['name']
        }

        Component.onCompleted: {
            if (!containerInfo['address'])
            {
                visible = false
                city.anchors.top = header.bottom
            }
        }
    }

    ListItem {
        id: city
        anchors {
            top: address.bottom
        }
        Label {
            text: containerInfo['city']
        }
    }

    ListItem {
        id: postalCode
        anchors {
            top: city.bottom
        }
        Label {
            text: containerInfo['postalCode']
        }
    }
}
