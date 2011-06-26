import QtQuick 1.0

import 'reittiopas.js' as Reittiopas
import 'reittiopas-hsl.js' as HSL
import 'helper.js' as Helper

Rectangle {

    // initilize helper
    Component.onCompleted: Helper.init();

    id: main
    width: 360
    height: 480

    Text {
        id: title
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        font.family: "Arial Hebrew"
        color: 'blue'
        font.pointSize: 25
        text: 'Perille'
    }

    Text {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        text: 'Exit'
        MouseArea {
            anchors.fill: parent
            onClicked: Qt.quit()
        }
    }

    // Here starts real app logic

    // helper JS


    function showAddressSuggestion(field, response) {

        routeOptionsModel.clear();
        for( var location in response ) {
            location = response[location]
            routeOptionsModel.append( {
                                     name : location.name,
                                     city : location.city,
                                     coord : location.coords,
                                     clickLocation : field
        } );
        }

    }

    function showRoute( r ) {
        // for initial release, only handle one route (the best one
        for( var index in r ) {
        var route = r[index][0];
        var points = [];
        for( var leg in route.legs ) {
            leg = route.legs[leg];
            // console.log( HSL.decode( leg ).type )
            leg = HSL.decode( leg )
            points.push( leg );
            Helper.DATA_MODELS[index].append( {
                                         type : leg.type,
                                         code : leg.code,
                                         first : leg.first.name,
                                         last: leg.last.name,
                                         time : leg.first.time,
                                         latitude : leg.first.location.x,
                                         longitude : leg.first.location.y
        } )
        }
        // need to loop this again... :(
        // at the initial time we can not confirtm that the values in models have been correct onces
        // the joy and love of async
        // xxx fixme
        Helper.DATA_CONTAINERS[index].model = Helper.DATA_MODELS[index];
        }

    }

    Item {
        id: search
        anchors.top: title.bottom
        x : title.anchors.leftMargin
        width: main.width
        height: main.width

        Behavior on x {
            NumberAnimation { duration: 2500 }
        }

        LocationEntry {
            id: from
            width: parent.parent.width - 2 * title.anchors.leftMargin
            text: 'From'

            function input(text) {
                if( text.length > 3 )
                    Reittiopas.address_to_location( text, function(response){ showAddressSuggestion(from, response)  } )
            }
        }

        LocationEntry {

            id: to
            width: from.width

            anchors.top: from.bottom
            anchors.topMargin: 10

            text: 'To'

            function input(text) {
                if( text.length > 3 )
                    Reittiopas.address_to_location( text, function(response){ showAddressSuggestion(to, response)  } )
            }

        }

        Rectangle {

            id: searchFrame
            anchors.top: to.bottom
            anchors.topMargin: 10

            radius: 10

            color:  'lightblue'
            border.color: 'lightblue'
            border.width: 2
            height: 75
            width: from.width

            Text {
                anchors.centerIn: parent
                text: 'Search'
                color: 'white'
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Reittiopas.route( from.coord, to.coord ,
                                     new Date() , // hardcoded
                                     'departure',
                                     showRoute )
                    // hide search, show result
                    // xxx fixme
                    routeOptionsModel.clear()
                    search.x = - main.width + title.anchors.leftMargin
                }
            }
        }

        ListModel {
            id: routeOptionsModel
        }

        ListView {
            id: routeOptions
            anchors.top: searchFrame.bottom
            anchors.topMargin: 10
            width: from.width
            orientation: ListView.Horizontal
            height: 70
            model: routeOptionsModel
            delegate: Item {
                height: 70
                width: 100
                Text {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text : name + ' (' + city + ')'
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        clickLocation.text = name;
                        clickLocation.coord = coord;
                        // routeOptionsModel.clear();
                    }
                }
            }
        }


    } // search end

    Item {
        id: response
        anchors.top: title.bottom
        anchors.topMargin: 10
        anchors.left: search.right
        width:  main.width

        Column {
            spacing: 5
            anchors.top: parent.top
            anchors.topMargin: 10

            Repeater {
                model: 5
                Item {
                    height: 70
                    width: main.width - 20
                    ListView {
                        id: list
                        Component.onCompleted: {
                            Helper.DATA_CONTAINERS.push(list);
                        }
                        width: from.width
                        orientation: ListView.Horizontal
                        height: parent.height
                        model: Helper.DATA_MODELS[index]
                        delegate: Item {
                            height: parent.height
                            width: 250

                            Text {
                                id: text
                                width: 140
                                wrapMode: Text.WordWrap
                                text : type + ' ' + code + ' @ ' + first + ' ' + Qt.formatTime( time, 'hh:mm' )
                            }

                            Image {
                                id: image

                                anchors.left: text.right
                                anchors.leftMargin: 5
                                anchors.top: text.top

                                source : 'http://perille.mante.li/streetimage/image.php?latitude=' + latitude + '&longitude=' + longitude
                                height: parent.height
                                width: 100
                                fillMode: Image.PreserveAspectFit
                                Behavior on scale {
                                    NumberAnimation { duration: 250 }
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        console.log("Mui")
                                        // fixme ? :
                                        if( parent.scale == 1 ) {
                                            parent.scale = 3;
                                        } else {
                                            parent.scale = 1;
                                        }
                                    }
                                }
                            }

                        }
                    }

                    // display indicator for more data

                    Text {
                        text: '>'
                        color: 'blue'
                        anchors.left: parent.right
                        anchors.horizontalCenter: parent.horizontalCenter
                        style: Text.Outline
                        styleColor: 'white'

                        visible: !list.atXEnd
                    }

                    Text {
                        text: '<'
                        color: 'blue'
                        anchors.right: parent.right
                        anchors.horizontalCenter: parent.horizontalCenter
                        style: Text.Outline
                        styleColor: 'white'

                        visible: !list.atXBeginning
                    }

                }
            }
        }


    } // response end

}
