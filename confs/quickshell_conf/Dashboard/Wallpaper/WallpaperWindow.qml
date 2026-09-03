import QtQuick
import QtCore
import Qt.labs.folderlistmodel
import Quickshell.Io
import "../../"

Item {
    id: root
    signal wallpaperSelected()

    property alias keyHandler: keyHandler   // exposes the focus target to DashboardPopup

    implicitWidth: 630
    implicitHeight: 160
    height: implicitHeight

    property int currentIndex: 0

    Component.onCompleted: wallpapers.refresh()   // forceActiveFocus() call removed — now driven externally

    Process { id: applyProcess }

    FolderListModel {
        id: wallpapers
        folder: StandardPaths.writableLocation(StandardPaths.HomeLocation) + "/wallpaper"
        nameFilters: ["*.jpg", "*.jpeg", "*.png"]
        showDirs: false
        sortField: FolderListModel.Name
    }

    function applyIndex(i) {
        if (i < 0 || i >= wallpapers.count) return
        const path = wallpapers.get(i, "filePath")
        applyProcess.command = ["waypaper", "--wallpaper", path]
        applyProcess.startDetached()
    }

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Colors.surface
        border.color: Colors.outline
        border.width: 1

        Item {
            id: keyHandler
            anchors.fill: parent
            focus: true

            Keys.onLeftPressed: {
                root.currentIndex = Math.max(0, root.currentIndex - 1)
                listView.positionViewAtIndex(root.currentIndex, ListView.Contain)
                root.applyIndex(root.currentIndex)
            }
            Keys.onRightPressed: {
                root.currentIndex = Math.min(wallpapers.count - 1, root.currentIndex + 1)
                listView.positionViewAtIndex(root.currentIndex, ListView.Contain)
                root.applyIndex(root.currentIndex)
            }
            Keys.onReturnPressed: root.wallpaperSelected()
            Keys.onEnterPressed: root.wallpaperSelected()

            ListView {
                id: listView
                anchors.fill: parent
                anchors.margins: 10
                orientation: ListView.Horizontal
                spacing: 12
                model: wallpapers
                clip: true

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
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
                        property bool keySelected: root.currentIndex === index
                        border.width: 2
                        border.color: (thumbMouse.containsMouse || keySelected) ? Colors.primary : "transparent"

                        scale: (thumbMouse.containsMouse || keySelected) ? 1.05 : 1.0
                        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

                        Image {
                            anchors.fill: parent
                            anchors.margins: 4
                            source: "file://" + filePath
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
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
                            onEntered: root.currentIndex = index
                            onClicked: {
                                root.currentIndex = index
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
}
