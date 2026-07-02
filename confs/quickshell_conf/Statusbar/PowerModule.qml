import QtQuick

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
        color: "gold"
        font.pixelSize: 16
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: powerRoot.open = !powerRoot.open
    }
}
