import QtQuick
import "../Notifications"

Rectangle {
    id: notificationsRoot
    width: 30
    height: 30
    radius: 15
    color: "transparent"

    property bool open: false
    readonly property int count: NotificationsServer.trackedNotifications.values.length

    Text {
        anchors.centerIn: parent
        text: "\uf0f3"
        color: "gold"
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
        anchors.fill: parent
        onClicked: notificationsRoot.open = !notificationsRoot.open
    }
}
