import QtQuick
import Quickshell
import "../"

PopupWindow {
    id: popup

    property Item anchorItem
    property int cpuPct: 0
    property int cpuTemp: 0
    property int gpuPct: 0
    property int gpuTemp: 0
    property int memPct: 0
    property real memUsedGB: 0
    property real memTotalGB: 0
    property real diskFreeGB: 0
    property real diskTotalGB: 0
    property real diskUsedGB: 0
    property real swapUsedGB: 0
    property real swapTotalGB: 0
    property var coreLoads: []
    property string uptimeStr: ""

    signal hoverEntered
    signal hoverExited

    implicitWidth: 300
    implicitHeight: content.implicitHeight + 24
    color: "transparent"

    anchor {
        item: popup.anchorItem
        edges: Edges.Bottom
        gravity: Edges.Bottom
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: popup.hoverEntered()
        onExited: popup.hoverExited()
    }

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Colors.surface
        border.color: "transparent"
        border.width: 1

        Column {
            id: content
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            Row {
                width: parent.width
                spacing: 10

                // --- GPU ---
                Column {
                    width: (parent.width - 20) / 3
                    spacing: 4
                    Text {
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "Usage " + popup.gpuPct + "%"
                        color: Colors.muted
                        font.pixelSize: 11
                    }
                    PieChart {
                        width: parent.width
                        height: width
                        value: popup.gpuPct
                        centerText: popup.gpuTemp + "°C"
                        valueColor: Colors.primary
                        trackColor: Colors.surfaceVariant
                        textColor: Colors.foreground
                    }
                    Text {
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "GPU"
                        color: Colors.muted
                        font.pixelSize: 11
                    }
                }

                // --- CPU ---
                Column {
                    width: (parent.width - 20) / 3
                    spacing: 4
                    Text {
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "Usage " + popup.cpuPct + "%"
                        color: Colors.muted
                        font.pixelSize: 11
                    }
                    PieChart {
                        width: parent.width
                        height: width
                        value: popup.cpuPct
                        centerText: popup.cpuTemp + "°C"
                        valueColor: Colors.primary
                        trackColor: Colors.surfaceVariant
                        textColor: Colors.foreground
                    }
                    Text {
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "CPU"
                        color: Colors.muted
                        font.pixelSize: 11
                    }
                }

                // --- Memory ---
                Column {
                    width: (parent.width - 20) / 3
                    spacing: 4
                    Text {
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "Storage " + popup.diskUsedGB.toFixed(0) + "GB"
                        color: Colors.muted
                        font.pixelSize: 11
                    }
                    PieChart {
                        width: parent.width
                        height: width
                        value: popup.memPct
                        centerText: popup.memUsedGB.toFixed(1) + "GB"
                        valueColor: Colors.primary
                        trackColor: Colors.surfaceVariant
                        textColor: Colors.foreground
                    }
                    Text {
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "RAM"
                        color: Colors.muted
                        font.pixelSize: 11
                    }
                }
            }

            Text {
                text: "Per core"
                color: Colors.muted
                font.pixelSize: 11
            }

            Grid {
                columns: 4
                spacing: 4
                width: parent.width
                Repeater {
                    model: popup.coreLoads
                    delegate: Rectangle {
                        width: (content.width - 12) / 4
                        height: 18
                        radius: 4
                        color: Colors.surfaceVariant
                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: parent.width * modelData / 100
                            radius: 4
                            color: Colors.primary
                        }
                        Text {
                            anchors.centerIn: parent
                            text: modelData + "%"
                            font.pixelSize: 9
                            color: Colors.foreground
                        }
                    }
                }
            }

            Text {
                visible: popup.swapTotalGB > 0
                text: "Swap  " + popup.swapUsedGB.toFixed(1) + " / " + popup.swapTotalGB.toFixed(1) + " GB"
                color: Colors.muted
                font.pixelSize: 12
            }

            Text {
                text: "Uptime  " + popup.uptimeStr
                color: Colors.muted
                font.pixelSize: 12
            }
        }
    }
}
