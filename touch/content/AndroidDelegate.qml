import QtQuick 2.2
import Example 1.0
Item {

    id: root
    height: 50
    width: 150
    signal clicked
    //anchors.verticalCenter: parent.verticalCenter
    anchors.margins: 200
    rotation: (index + 3) * 60
    //anchors.leftMargin: 30




    Image {
        id: thing
        anchors.verticalCenter: parent.verticalCenter
        source: Qt.resolvedUrl("../images/area.png")
        height: 200;
        width: 200;
        asynchronous: true;
        fillMode: Image.PreserveAspectFit
        scale: thingArea.pressed ? 1 : 1.2

        Text {
            id: textitem
            color: "white"
            font.pixelSize: 32
            text: title
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.fill: parent
            rotation: (index-3) * -60
        }
        MaskedMouseArea {
            id: thingArea
            anchors.fill: parent
            alphaThreshold: 0.4
            maskSource: thing.source
            onClicked: root.clicked()
        }
        Behavior on scale {
            NumberAnimation { duration: 100 }
        }
    }


}
