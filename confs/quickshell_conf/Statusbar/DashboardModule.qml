import QtQuick
import Quickshell
import "../"
import "../Dashboard"

Rectangle {
    id: dashboardRoot
    implicitWidth: 30
    height: 30
    radius: 15
    color: mouseArea.containsMouse ? Colors.surfaceVariant : "transparent"

    property bool open: false

    Text {
        anchors.centerIn: parent
        text: "\uf3fd"
        font.family: "Font Awesome 7 Free"
        font.weight: Font.Black
        color: Colors.foreground
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: dashboardRoot.open = !dashboardRoot.open
    }

    DashboardPopup {
        anchorItem: dashboardRoot
        visible: dashboardRoot.open
        onClosed: dashboardRoot.open = false
    }
}
