import QtQuick 2.5
import QtQuick.Controls 1.2
import "content"
import Example 1.0

ApplicationWindow {
    visible: true
    width: 1320
    height: 1080

    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }

    toolBar: BorderImage {
        border.bottom: 8
        source: "images/toolbar.png"
        width: parent.width
        height: 60

        Rectangle {
            id: backButton
            width: opacity ? 60 : 0
            anchors.left: parent.left
            anchors.leftMargin: 20
            opacity: stackView.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: 60
            radius: 4
            color: backmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "images/navigation_previous_item.png"
            }
            MouseArea {
                id: backmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: stackView.pop()
            }
        }

        Text {
            font.pixelSize: 42
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 20
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: "CarPi V1.0.0"
        }
        Item {

            id: clock
            width : columnLayout.width
            height : parent.height
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter

            property color textColor : "white"
            property int fontSize : 42
            property int fontSizeDate: 15
            property string hours : "00"
            property string minutes : "00"
            property string seconds : "00"
            property string date: ""
            property variant shift : 0
            property bool showSeconds : false
            property bool showDate : false

            function timeChanged() {

                // To be fixed to fit locale
                var Month = new Array("January", "February", "March", "April", "May", "June",
                                      "July", "August", "September", "October", "November", "December");
                var d = new Date;


                // hours
                var tmp = checkTime(shift ? d.getUTCHours() + Math.floor(clock.shift) : d.getHours())
                if (tmp != hours) {
                    hours = tmp
                }

                // minutes
                tmp = checkTime(shift ? d.getUTCMinutes() + ((clock.shift % 1) * 60) : d.getMinutes())
                if (tmp != minutes) {
                    minutes = tmp
                }

                // seconds
                seconds = checkTime(d.getUTCSeconds())


                // get Date
                date = Month[d.getMonth()] +" " + d.getDate()+ ", " + d.getFullYear();
            }


            function checkTime(i) {
                return (i<10) ? "0"+ i : i;
            }

            FontLoader {
                id: font
                source: "digital-7.ttf"
            }

            Timer {
                interval: 1000; running: true; repeat: true; triggeredOnStart: true
                onTriggered: clock.timeChanged()
            }


            Column {

                id: columnLayout

                Row {
                    id : rowLayout
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: hoursText
                        color: clock.textColor
                        text: clock.hours
                        font.pixelSize: clock.fontSize
                        font.family: font.name
                    }


                    Text {
                        id: colon
                        width: 30
                        text: blink? " : " : "   "
                        color: clock.textColor
                        font.pixelSize: clock.fontSize
                        font.family: font.name

                        property bool blink: false;
                        Timer {
                            interval: 500; running: true; repeat: true; triggeredOnStart: true
                            onTriggered: colon.blink = !colon.blink
                        }
                    }

                    Text {
                        id : minutesText
                        text: clock.minutes
                        color: clock.textColor
                        font.pixelSize: clock.fontSize
                        font.family: font.name
                    }


                    Text {
                        text: " : "
                        color: clock.textColor
                        font.pixelSize: clock.fontSize
                        visible : clock.showSeconds
                        font.family: font.name
                    }


                    Text {
                        id : secondsText
                        text: clock.seconds
                        color: clock.textColor
                        font.pixelSize: clock.fontSize
                        visible : clock.showSeconds
                        font.family: font.name
                    }

                }


                Text {
                    id : dateText
                    text: clock.date
                    font.family: "Calibri"
                    color: parent.parent.textColor
                    font.pixelSize: clock.fontSizeDate
                    visible : clock.showDate
                    anchors.top : parent.parent.bottom
                }

            }

        }
    }

    ListModel {
        id: pageModel
        ListElement {
            title: "Music"
            page: "content/ButtonPage.qml"
            index: 1
        }
        ListElement {
            title: "Radio"
            page: "content/SliderPage.qml"
            index: 2
        }
        ListElement {
            title: "GPS"
            page: "content/ProgressBarPage.qml"
            index: 3
        }
        ListElement {
            title: "Settings"
            page: "content/TabBarPage.qml"
            index: 4
        }
        ListElement {
            title: "Camera"
            page: "content/TextInputPage.qml"
            index: 5
        }
        ListElement {
            title: "More"
            page: "content/ListPage.qml"
            index: 6
        }
        //        ListElement {
        //            title: "C"
        //            page: "content/ProgressBarPage.qml"
        //        }
        //        ListElement {
        //            title: "D"
        //            page: "content/TabBarPage.qml"
        //        }
        //        ListElement {
        //            title: "E"
        //            page: "content/TextInputPage.qml"
        //        }
        //        ListElement {
        //            title: "F"
        //            page: "content/ListPage.qml"
        //        }
    }


    StackView {
        id: stackView
        anchors.fill: parent
        // Implements back key navigation
        focus: true
        Keys.onReleased: if (event.key === Qt.Key_Back && stackView.depth > 1) {
                             stackView.pop();
                             event.accepted = true;
                         }

        initialItem: Item {
            width: parent.width
            height: parent.height
            anchors.fill: parent
            Rectangle {
                color: "#696969"
                width: 600
                height: 600
                radius: 300
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                radius: width/2
                width: 200
                height: 200
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/bmwlogo.png"
                    height: parent.hight;
                    width: parent.width;
                    asynchronous: true;
                    fillMode: Image.PreserveAspectFit
                }
            }
            PathView {
                id: path
                width: parent.width; height: parent.height
                model: pageModel
                //anchors.fill: parent
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                delegate: AndroidDelegate {
                    //text: modelData
                    onClicked: stackView.push(Qt.resolvedUrl(page))
                }
                path: Path {
                    startX: path.width/2 - 200; startY: path.height/2;
                    PathArc {
                        relativeX: 400; relativeY: 0
                        radiusX: 200; radiusY: 200
                        useLargeArc: true
                    }
                    PathArc {
                        relativeX: -400; relativeY: 0
                        radiusX: 200; radiusY: 200
                        useLargeArc: true
                    }
                }
                focus: true
                Keys.onLeftPressed: decrementCurrentIndex()
                Keys.onRightPressed: incrementCurrentIndex()

            }

        }



    }
}


