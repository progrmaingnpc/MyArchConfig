import QtQuick
import "../"
import "../Notifications"

Rectangle {
    id: notificationsRoot
    width: 30
    height: 30
    radius: 15
    color: mouseArea.containsMouse ? Colors.surfaceVariant : "transparent"

    property bool open: false
    readonly property int count: NotificationsServer.trackedNotifications.values.length

    Text {
        anchors.centerIn: parent
        text: "\uf0f3"
        color: Colors.muted
        font.pixelSize: 15
    }

    Rectangle {
        visible: notificationsRoot.count > 0
        width: 8
        height: 8
        radius: 4
        color: "red"
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 2
        anchors.rightMargin: 2
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: notificationsRoot.open = !notificationsRoot.open
    }
}
