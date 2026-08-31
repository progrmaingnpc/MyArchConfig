import QtQuick
import "../"
import "../Power"

Rectangle {
    id: powerRoot
    width: 30
    height: 30
    radius: 15
    color: "transparent"

    property bool open: false

    Text {
        anchors.centerIn: parent
        text: "⏻"
        color: Colors.foreground
        font.pixelSize: 16
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: powerRoot.open = !powerRoot.open
    }

    PowerMenu {
        anchorItem: powerRoot
        visible: powerRoot.open
        onPowerOptionSelected: powerRoot.open = false
    }
}
