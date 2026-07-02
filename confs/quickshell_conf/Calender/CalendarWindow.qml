import QtQuick
import Quickshell

PopupWindow {
    id: root
    color: "black"

    readonly property int cellSize: 32
    implicitWidth: cellSize * 7 + 20
    implicitHeight: cellSize * 8 + 24

    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.top: 8

    property var today: new Date()
    property int viewYear: today.getFullYear()
    property int viewMonth: today.getMonth()
    property var days: []

    readonly property var monthNames: ["January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"]
    readonly property var dayNames: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

    function buildDays() {
        const firstDay = new Date(viewYear, viewMonth, 1).getDay() // 0 Sun..6 Sat
        const offset = (firstDay + 6) % 7 // Monday-first offset
        const daysInMonth = new Date(viewYear, viewMonth + 1, 0).getDate()
        const cells = []
        for (let i = 0; i < offset; i++) cells.push(0)
        for (let d = 1; d <= daysInMonth; d++) cells.push(d)
        while (cells.length % 7 !== 0) cells.push(0)
        return cells
    }

    function goPrevMonth() {
        viewMonth--
        if (viewMonth < 0) { viewMonth = 11; viewYear--; }
        days = buildDays()
    }

    function goNextMonth() {
        viewMonth++
        if (viewMonth > 11) { viewMonth = 0; viewYear++; }
        days = buildDays()
    }

    onVisibleChanged: {
        if (visible) {
            today = new Date()
            viewYear = today.getFullYear()
            viewMonth = today.getMonth()
            days = buildDays()
        }
    }

    Component.onCompleted: days = buildDays()

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6

        Row {
            width: root.cellSize * 7
            height: 24

            Text {
                width: root.cellSize
                height: 24
                text: "<"
                color: "gold"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.goPrevMonth()
                }
            }

            Text {
                width: root.cellSize * 5
                height: 24
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "gold"
                font.bold: true
                text: root.monthNames[root.viewMonth] + " " + root.viewYear
            }

            Text {
                width: root.cellSize
                height: 24
                text: ">"
                color: "gold"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.goNextMonth()
                }
            }
        }

        Grid {
            columns: 7

            Repeater {
                model: root.dayNames

                Text {
                    width: root.cellSize
                    height: 20
                    horizontalAlignment: Text.AlignHCenter
                    color: "gold"
                    font.bold: true
                    text: modelData
                }
            }
        }

        Grid {
            columns: 7

            Repeater {
                model: root.days

                Rectangle {
                    width: root.cellSize
                    height: root.cellSize
                    radius: width / 2
                    color: isToday ? "gold" : "transparent"

                    property bool isToday: modelData !== 0
                        && root.viewYear === root.today.getFullYear()
                        && root.viewMonth === root.today.getMonth()
                        && modelData === root.today.getDate()

                    Text {
                        anchors.centerIn: parent
                        visible: modelData !== 0
                        text: modelData
                        color: parent.isToday ? "black" : "gold"
                        font.bold: parent.isToday
                    }
                }
            }
        }
    }
}
