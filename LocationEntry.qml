import QtQuick 1.0

import 'reittiopas.js' as Reittiopas

// import QtMobility.location 1.1

Rectangle {

    border.color: 'lightblue'
    border.width: 2
    height: 75
    radius: 10

    property string coord
    property alias text: entry.text

    Rectangle {
        width: parent.width - 10 - 90
        height: 20
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter

        border.color: entry.focus ? 'blue' : 'lightgrey'
        border.width: 1

        TextInput {
            id : entry
            anchors.fill: parent
            font.pixelSize: parent.height - 2
            onTextChanged: input(text)
        }
    }

    /*
    Rectangle {
        width: 80
        height: 20
        anchors.right: parent.right
        anchors.rightMargin: 3
        anchors.verticalCenter: parent.verticalCenter
        radius: 5
        border.color: locationMouseArea.pressed ? 'darkblue' : 'pink'
        border.width: 2

        Text {
            anchors.centerIn: parent
            text: 'My location'
        }

        MouseArea {
            id: locationMouseArea
            anchors.fill: parent
            onClicked: {
                console.log( location.coordinate.latitude )
                console.log( location.coordinate.longitude )
                console.log( location.timestamp )
            }
        }
    }
    */

   /* Position {
        id : location
    }*/
}
