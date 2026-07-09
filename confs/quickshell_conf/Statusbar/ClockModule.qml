import Quickshell
import QtQuick
import "../Calendar"

Rectangle {
    id: clockRoot
    width: 110
    height: 30
    radius: 15
    color: "transparent"

    property bool open: false
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

    // debounce: only close if, after a short delay, neither
    // the trigger nor the popup is hovered anymore
    Timer {
        id: closeTimer
        interval: 200
        onTriggered: {
            if (!triggerHover.hovered && !calendarPopup.popupHovered)
                clockRoot.open = false
        }
    }

    HoverHandler {
        id: triggerHover
        onHoveredChanged: {
            if (hovered) {
                closeTimer.stop()
                clockRoot.open = true
            } else {
                closeTimer.restart()
            }
        }
    }

    CalendarWindow {
        id: calendarPopup
        anchor.item: clockRoot
        visible: clockRoot.open

        onPopupHoveredChanged: {
            if (popupHovered) {
                closeTimer.stop()
            } else {
                closeTimer.restart()
            }
        }
    }
}
