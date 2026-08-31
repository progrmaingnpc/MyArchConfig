import QtQuick
import Quickshell
import "../"
import "../Wallpaper"

Rectangle {
    id: wallpaperRoot
    width: 30
    height: 30
    radius: 15
    color: "transparent"

    property bool open: false
    Text {
        anchors.centerIn: parent
        color: Colors.muted
        font.pixelSize: 15
        font.family: "Font Awesome 7 Free"
        font.weight: Font.Black
        text: "\uf03e"
    }
    MouseArea {
        anchors.fill: parent
        onClicked: wallpaperRoot.open = !wallpaperRoot.open
    }
    WallpaperWindow {
        anchorItem: wallpaperRoot
        visible: wallpaperRoot.open       // binding stays intact now
        onWallpaperSelected: wallpaperRoot.open = false
    }
}
