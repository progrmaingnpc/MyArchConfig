import Quickshell
import QtQuick

Rectangle {
    id: clockRoot
    width: 110
    height: 30
    color: "transparent"

    property bool showDate: false

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Text {
        color: "#FFD700"
        anchors.centerIn: parent
        text: clockRoot.showDate
            ? Qt.formatDateTime(clock.date, "dd/MM/yyyy")
            : Qt.formatDateTime(clock.date, "hh:mm AP")
    }

    MouseArea {
        anchors.fill: parent
        onClicked: clockRoot.showDate = !clockRoot.showDate
    }
}
