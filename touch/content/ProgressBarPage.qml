/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtBluetooth 5.2


Item {

    width: parent.width
    height: parent.height
    id: top

    property real progress: 0
    SequentialAnimation on progress {
        loops: Animation.Infinite
        running: true
        NumberAnimation {
            from: 0
            to: 1
            duration: 3000
        }
        NumberAnimation {
            from: 1
            to: 0
            duration: 3000
        }
    }

    BluetoothDiscoveryModel {
            id: btModel
            running: true
            discoveryMode: BluetoothDiscoveryModel.DeviceDiscovery
            onDiscoveryModeChanged: console.log("Discovery mode: " + discoveryMode)
            onServiceDiscovered: console.log("Found new service " + service.deviceAddress + " " + service.deviceName + " " + service.serviceName);
            onDeviceDiscovered: console.log("New device: " + device)
            onErrorChanged: {
                    switch (btModel.error) {
                    case BluetoothDiscoveryModel.PoweredOffError:
                        console.log("Error: Bluetooth device not turned on"); break;
                    case BluetoothDiscoveryModel.InputOutputError:
                        console.log("Error: Bluetooth I/O Error"); break;
                    case BluetoothDiscoveryModel.InvalidBluetoothAdapterError:
                        console.log("Error: Invalid Bluetooth Adapter Error"); break;
                    case BluetoothDiscoveryModel.NoError:
                        break;
                    default:
                        console.log("Error: Unknown Error"); break;
                    }
            }
       }

    Column {
        spacing: 40
        anchors.centerIn: parent

        ProgressBar {
            anchors.margins: 20
            style: touchStyle
            width: 400
            value: progress
        }

        ProgressBar {
            anchors.margins: 20
            style: touchStyle
            width: 400
            value: 1 - progress
        }

        ProgressBar {
            anchors.margins: 20
            style: touchStyle
            value: 1
            width: 400
        }

    }
    ListView {
            id: mainList
            width: top.width
            anchors.top: busy.bottom
            anchors.bottom: buttonGroup.top
            anchors.bottomMargin: 10
            anchors.topMargin: 10
            clip: true

            model: btModel
            delegate: Rectangle {
                id: btDelegate
                width: parent.width
                height: column.height + 10

                property bool expended: false;
                clip: true
                Image {
                    id: bticon
                    source: "qrc:/default.png";
                    width: bttext.height;
                    height: bttext.height;
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 5
                }

                Column {
                    id: column
                    anchors.left: bticon.right
                    anchors.leftMargin: 5
                    Text {
                        id: bttext
                        text: deviceName ? deviceName : name
                        font.family: "FreeSerif"
                        font.pointSize: 16
                    }

                    Text {
                        id: details
                        function get_details(s) {
                            if (btModel.discoveryMode == BluetoothDiscoveryModel.DeviceDiscovery) {
                                //We are doing a device discovery
                                var str = "Address: " + remoteAddress;
                                return str;
                            } else {
                                var str = "Address: " + s.deviceAddress;
                                if (s.serviceName) { str += "<br>Service: " + s.serviceName; }
                                if (s.serviceDescription) { str += "<br>Description: " + s.serviceDescription; }
                                if (s.serviceProtocol) { str += "<br>Protocol: " + s.serviceProtocol; }
                                return str;
                            }
                        }
                        visible: opacity !== 0
                        opacity: btDelegate.expended ? 1 : 0.0
                        text: get_details(service)
                        font.family: "FreeSerif"
                        font.pointSize: 14
                        Behavior on opacity {
                            NumberAnimation { duration: 200}
                        }
                    }
                }
                Behavior on height { NumberAnimation { duration: 200} }

                MouseArea {
                    anchors.fill: parent
                    onClicked: btDelegate.expended = !btDelegate.expended
                }
            }
            focus: true
        }


    Component {
        id: touchStyle
        ProgressBarStyle {
            panel: Rectangle {
                implicitHeight: 15
                implicitWidth: 400
                color: "#444"
                opacity: 0.8
                Rectangle {
                    antialiasing: true
                    radius: 1
                    color: "#468bb7"
                    height: parent.height
                    width: parent.width * control.value / control.maximumValue
                }
            }
        }
    }
}
