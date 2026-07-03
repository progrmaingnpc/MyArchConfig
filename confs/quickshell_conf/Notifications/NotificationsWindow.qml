import QtQuick
import Quickshell

PopupWindow {
    id: root
    color: "black"

    property Item anchorItem

    anchor.item: anchorItem
    anchor.edges: Edges.Bottom | Edges.Right
    anchor.gravity: Edges.Bottom | Edges.Center
    anchor.margins.top: 8

    implicitWidth: 320
    implicitHeight: Math.max(60, Math.min(420, list.contentHeight + 20))

    ListView {
        id: list
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        clip: true
        model: NotificationsServer.trackedNotifications

        delegate: Rectangle {
            width: list.width
            height: Math.max(56, body.implicitHeight + summary.implicitHeight + 20)
            radius: 8
            color: "#1a1a1a"

            Column {
                anchors.fill: parent
                anchors.margins: 8
                anchors.rightMargin: 26
                spacing: 2

                Text {
                    id: summary
                    width: parent.width
                    text: modelData.summary
                    color: "gold"
                    font.bold: true
                    elide: Text.ElideRight
                }

                Text {
                    id: body
                    width: parent.width
                    text: modelData.body
                    color: "gold"
                    wrapMode: Text.WordWrap
                    maximumLineCount: 3
                    elide: Text.ElideRight
                }
            }

            Text {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 6
                text: "x"
                color: "gold"
                font.bold: true

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -6
                    onClicked: modelData.dismiss()
                }
            }
        }
    }

    Text {
        anchors.centerIn: parent
        visible: list.count === 0
        text: "No notifications"
        color: "gold"
    }
}
