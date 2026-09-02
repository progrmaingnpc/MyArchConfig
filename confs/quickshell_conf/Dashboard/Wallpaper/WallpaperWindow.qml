import QtQuick
import QtCore
import Qt.labs.folderlistmodel
import Quickshell.Io
import "../../"

Item {
    id: root
    signal wallpaperSelected()

    // 1. Dynamic dimensions tightly wrapped around the horizontal list layout
    implicitWidth: 630
    implicitHeight: 160 // Fixed height for 1 row of cards + padding
    height: implicitHeight

    Component.onCompleted: wallpapers.refresh()

    Process { id: applyProcess }

    FolderListModel {
        id: wallpapers
        folder: StandardPaths.writableLocation(StandardPaths.HomeLocation) + "/wallpaper"
        nameFilters: ["*.jpg", "*.jpeg", "*.png"]
        showDirs: false
        sortField: FolderListModel.Name
    }

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Colors.surface
        border.color: Colors.outline
        border.width: 1

        // 2. Horizontal ListView with mouse wheel scroll handling
        ListView {
            id: listView
            anchors.fill: parent
            anchors.margins: 10
            orientation: ListView.Horizontal
            spacing: 12
            model: wallpapers
            clip: true

            // Convert vertical mouse scroll wheel into smooth horizontal movement
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.NoButton // Allows item clicks to pass through to delegates
                onWheel: (wheel) => {
                    if (wheel.angleDelta.y !== 0) {
                        listView.contentX = Math.max(0, Math.min(listView.contentX - wheel.angleDelta.y, listView.contentWidth - listView.width));
                    }
                }
            }

            delegate: Item {
                width: 200
                height: 140

                Rectangle {
                    id: card
                    anchors.centerIn: parent
                    width: 192
                    height: 132
                    radius: 8
                    color: "transparent"
                    border.width: 2
                    border.color: thumbMouse.containsMouse ? Colors.primary : "transparent"

                    // 3. Smooth hover scaling transformation
                    scale: thumbMouse.containsMouse ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

                    Image {
                        anchors.fill: parent
                        anchors.margins: 4
                        source: "file://" + filePath
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true

                        // Round corners on the preview image
                        layer.enabled: true
                    }

                    Text {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 8
                        text: fileName
                        color: Colors.foreground
                        font.bold: true
                        font.pixelSize: 11
                        elide: Text.ElideRight
                        style: Text.Outline
                        styleColor: Colors.surface
                    }

                    MouseArea {
                        id: thumbMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            applyProcess.command = ["waypaper", "--wallpaper", filePath];
                            applyProcess.startDetached();
                            root.wallpaperSelected();
                        }
                    }
                }
            }
        }
    }
}
