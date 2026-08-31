import QtQuick
import QtCore
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io
import "../"

PopupWindow {
    id: root

    property var anchorItem: null
    signal wallpaperSelected()
    anchor.item: anchorItem
    anchor.rect.x: anchorItem ? 0 : 0
    anchor.rect.y: anchorItem ? anchorItem.height : 0
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom

    implicitWidth: 700
    implicitHeight: 500
    color: Colors.background

    Process {
        id: applyProcess
    }

    FolderListModel {
        id: wallpapers
        folder: StandardPaths.writableLocation(StandardPaths.HomeLocation) + "/wallpaper"
        nameFilters: ["*.jpg", "*.jpeg", "*.png"]
        showDirs: false
        sortField: FolderListModel.Name
    }

    GridView {
        anchors.fill: parent
        anchors.margins: 16
        cellWidth: 210
        cellHeight: 140
        model: wallpapers
        clip: true
        delegate: Rectangle {
            width: 194
            height: 124
            radius: 6
            color: "transparent"
            border.width: 2
            border.color: thumbMouse.containsMouse ? Colors.outline : "transparent"
            Image {
                anchors.fill: parent
                anchors.margins: 4
                source: "file://" + filePath
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
            }
            Text {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.margins: 6
                text: fileName
                color: Colors.foreground
                font.bold: true
                style: Text.Outline
                styleColor: Colors.background
            }
            MouseArea {
                id: thumbMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    applyProcess.command = ["waypaper", "--wallpaper", filePath];
                    applyProcess.startDetached();
                    root.wallpaperSelected()  // close the picker after selecting
                }
            }
        }
    }
}
