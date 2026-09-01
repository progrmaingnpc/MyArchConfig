import QtQuick
import Quickshell
import Quickshell.Networking
import "../"

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

    // Delay closing to give the mouse time to move onto the popup window
    Timer {
        id: closeTimer
        interval: 150
        repeat: false
        onTriggered: {
            if (!mouseArea.containsMouse && !popupHover.hovered) {
                networkRoot.open = false;
            }
        }
    }

    Text {
        anchors.centerIn: parent
        color: Colors.muted
        font.family: "Font Awesome 7 Free"
        font.weight: Font.Black
        text: networkRoot.icon
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.RightButton

        onEntered: {
            closeTimer.stop();
            networkRoot.open = true;
        }
        onExited: closeTimer.restart()

        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                Quickshell.execDetached(["nm-connection-editor"]);
            }
        }
    }

    NetworkPopup {
        id: popup
        anchorItem: networkRoot
        visible: networkRoot.open

        // Tracks hover on the popup without intercepting clicks or scroll events
        HoverHandler {
            id: popupHover
            onHoveredChanged: {
                if (hovered) {
                    closeTimer.stop();
                } else {
                    closeTimer.restart();
                }
            }
        }
    }
}
