import QtQuick
import "../../"

Item {
    id: root
    property int cpuPct: 0
    property int cpuTemp: 0
    property int gpuPct: 0
    property int gpuTemp: 0
    property int memPct: 0
    property real memUsedGB: 0
    property real memTotalGB: 0
    property real diskUsedGB: 0
    property real swapUsedGB: 0
    property real swapTotalGB: 0
    property var coreLoads: []
    property string uptimeStr: ""

    // Strictly match the height of the column plus 24px inner padding
    implicitWidth: 316
    implicitHeight: content.height + 24
    height: implicitHeight

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Colors.surface
        border.color: Colors.outline
        border.width: 1

        Column {
            id: content
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 12
            spacing: 12

            Row {
                width: parent.width
                spacing: 10

                Column {
                    width: (parent.width - 20) / 3
                    spacing: 4
                    Text { width: parent.width; horizontalAlignment: Text.AlignHCenter; text: root.gpuPct + "% Usage"; color: Colors.muted; font.pixelSize: 11 }
                    PieChart {
                        width: parent.width; height: width
                        value: root.gpuPct
                        centerText: root.gpuTemp + "°C"
                        valueColor: Colors.primary
                        trackColor: Colors.surfaceVariant
                        textColor: Colors.foreground
                    }
                    Text { width: parent.width; horizontalAlignment: Text.AlignHCenter; text: "GPU"; color: Colors.muted; font.pixelSize: 11 }
                }

                Column {
                    width: (parent.width - 20) / 3
                    spacing: 4
                    Text { width: parent.width; horizontalAlignment: Text.AlignHCenter; text: root.cpuPct + "% Usage"; color: Colors.muted; font.pixelSize: 11 }
                    PieChart {
                        width: parent.width; height: width
                        value: root.cpuPct
                        centerText: root.cpuTemp + "°C"
                        valueColor: Colors.primary
                        trackColor: Colors.surfaceVariant
                        textColor: Colors.foreground
                    }
                    Text { width: parent.width; horizontalAlignment: Text.AlignHCenter; text: "CPU"; color: Colors.muted; font.pixelSize: 11 }
                }

                Column {
                    width: (parent.width - 20) / 3
                    spacing: 4
                    Text { width: parent.width; horizontalAlignment: Text.AlignHCenter; text: root.diskUsedGB.toFixed(0) + "GiB Storage"; color: Colors.muted; font.pixelSize: 11 }
                    PieChart {
                        width: parent.width; height: width
                        value: root.memPct
                        centerText: root.memUsedGB.toFixed(1) + "GB"
                        valueColor: Colors.primary
                        trackColor: Colors.surfaceVariant
                        textColor: Colors.foreground
                    }
                    Text { width: parent.width; horizontalAlignment: Text.AlignHCenter; text: "RAM"; color: Colors.muted; font.pixelSize: 11 }
                }
            }

            Text { text: "Per core"; color: Colors.muted; font.pixelSize: 11 }

            Grid {
                columns: 4
                spacing: 4
                width: parent.width
                Repeater {
                    model: root.coreLoads
                    delegate: Rectangle {
                        width: (content.width - 12) / 4
                        height: 18
                        radius: 4
                        color: Colors.surfaceVariant
                        Rectangle {
                            anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom
                            width: parent.width * modelData / 100
                            radius: 4
                            color: Colors.primary
                        }
                        Text { anchors.centerIn: parent; text: modelData + "%"; font.pixelSize: 9; color: Colors.foreground }
                    }
                }
            }

            Text { visible: root.swapTotalGB > 0; text: "Swap  " + root.swapUsedGB.toFixed(1) + " / " + root.swapTotalGB.toFixed(1) + " GB"; color: Colors.muted; font.pixelSize: 12 }
            Text { text: "Uptime  " + root.uptimeStr; color: Colors.muted; font.pixelSize: 12 }
        }
    }
}
