import QtQuick
import Quickshell

Rectangle {
    id: wallpaperRoot
    width: 30
    height: 30
    radius: 15
    color: "transparent"

    Text {
        anchors.centerIn: parent
        color: "gold"
        font.pixelSize: 15
        font.family: "Font Awesome 7 Free"
        font.weight: Font.Black
        text: "\uf03e"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["qs", "-p", Quickshell.shellPath("Wallpaper")])
    }
}
