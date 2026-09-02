import QtQuick
import "../../"

Rectangle {
    id: root
    anchors.fill: parent
    radius: 12
    color: Colors.surfaceContainer
    border.color: Colors.outline
    border.width: 1

    readonly property int cellSize: 38
    readonly property int rowCount: Math.ceil(days.length / 7)

    // Dynamically scale implicit height based on whether month needs 5 or 6 rows
    implicitWidth: (cellSize * 7) + 20
    implicitHeight: 28 + 22 + (rowCount * cellSize) + (rowCount * 2) + 20

    property var today: new Date()
    property int viewYear: today.getFullYear()
    property int viewMonth: today.getMonth()
    property var days: []

    readonly property var monthNames: ["January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"]
    readonly property var dayNames: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

    function buildDays() {
        const firstDay = new Date(viewYear, viewMonth, 1).getDay()
        const offset = (firstDay + 6) % 7
        const daysInMonth = new Date(viewYear, viewMonth + 1, 0).getDate()
        const cells = []
        
        for (let i = 0; i < offset; i++) cells.push(0)
        for (let d = 1; d <= daysInMonth; d++) cells.push(d)
        
        // Pad only to finish the last active row (5 or 6 rows depending on month)
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

    Component.onCompleted: days = buildDays()

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 2

        // Month Navigation Header
        Row {
            width: root.cellSize * 7
            height: 28

            Text {
                width: root.cellSize
                height: parent.height
                text: "<"
                color: Colors.muted
                font.bold: true
                font.pixelSize: 13
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.goPrevMonth()
                }
            }

            Text {
                width: root.cellSize * 5
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: Colors.foreground
                font.bold: true
                font.pixelSize: 13
                text: root.monthNames[root.viewMonth] + " " + root.viewYear
            }

            Text {
                width: root.cellSize
                height: parent.height
                text: ">"
                color: Colors.muted
                font.bold: true
                font.pixelSize: 13
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.goNextMonth()
                }
            }
        }

        // Days Header
        Grid {
            columns: 7
            Repeater {
                model: root.dayNames
                Text {
                    width: root.cellSize
                    height: 22
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: Colors.muted
                    font.bold: true
                    font.pixelSize: 11
                    text: modelData
                }
            }
        }

        // Days Grid (Adjusts dynamically between 5 and 6 rows)
        Grid {
            columns: 7
            rowSpacing: 2
            Repeater {
                model: root.days
                Rectangle {
                    width: root.cellSize
                    height: root.cellSize
                    radius: width / 2
                    color: isToday ? Colors.primary : "transparent"

                    property bool isToday: modelData !== 0
                        && root.viewYear === root.today.getFullYear()
                        && root.viewMonth === root.today.getMonth()
                        && modelData === root.today.getDate()

                    Text {
                        anchors.centerIn: parent
                        visible: modelData !== 0
                        text: modelData
                        color: parent.isToday ? Colors.onPrimary : Colors.foreground
                        font.bold: parent.isToday
                        font.pixelSize: 12
                    }
                }
            }
        }
    }
}
