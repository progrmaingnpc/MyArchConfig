import QtQuick
import Quickshell
import Quickshell.Networking

Rectangle {
    id: networkRoot
    width: 30
    height: 30
    color: "transparent"

    readonly property var devices: Networking.devices ? Networking.devices.values : []
    readonly property var wiredDevice: devices.find(d => d.type === DeviceType.Wired && d.connected)
    readonly property var wifiDevice: devices.find(d => d.type === DeviceType.Wifi && d.connected)

    readonly property string icon: wiredDevice ? "\uf796" : (wifiDevice ? "\uf1eb" : "\uf071")

    property bool open: false

    Text {
        anchors.centerIn: parent
        color: "gold"
        font.family: "Font Awesome 7 Free"
        font.weight: Font.Black
        text: networkRoot.icon
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                Quickshell.execDetached(["nm-connection-editor"]);
            } else {
                networkRoot.open = !networkRoot.open;
            }
        }
    }
}
