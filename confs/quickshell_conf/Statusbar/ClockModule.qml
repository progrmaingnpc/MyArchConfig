import Quickshell
import QtQuick

Rectangle {
    id: clockRoot
    width: 110
    height: 30
    radius: 15
    color: "transparent"

    property bool showDate: false
    readonly property alias hovered: clockMouseArea.containsMouse

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Text {
        color: "gold"
        anchors.centerIn: parent
        text: clockRoot.showDate ? Qt.formatDateTime(clock.date, "dd/MM/yyyy") : Qt.formatDateTime(clock.date, "hh:mm AP")
    }

    MouseArea {
        id: clockMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: clockRoot.showDate = !clockRoot.showDate
    }
}
