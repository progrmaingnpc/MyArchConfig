import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

Rectangle {
    id: workspacesRoot
    color: "transparent"
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    Row {
        id: content
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        // Map workspace indices (0-based) to Roman numerals
        property var romanMap: ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"]
        readonly property int activeId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1

        // --- 1. The First 5 Static Workspaces ---
        Repeater {
            model: 5
            Rectangle {
                width: 30
                height: 30
                radius: 4

                // Active (Yellow: #f9e2af) | Inactive (Grey: #45475a)
                color: (content.activeId === index + 1) ? "#f9e2af" : "#45475a"

                Text {
                    anchors.centerIn: parent
                    text: content.romanMap[index]
                    color: (content.activeId === index + 1) ? "#11111b" : "#cdd6f4"
                    font.bold: true
                }

                // Clicking a workspace switches to it via hyprctl
                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                }
            }
        }

        // --- 2. The Dynamic Overflow Slot (Workspaces 6-10) ---
        Rectangle {
            width: 30
            height: 30
            radius: 4

            // Only visible if active workspace is between 6 and 10
            visible: content.activeId >= 6 && content.activeId <= 10
            color: "#f9e2af" // Always yellow when visible because it IS the active workspace

            Text {
                anchors.centerIn: parent
                text: visible ? content.romanMap[content.activeId - 1] : ""
                color: "#11111b"
                font.bold: true
            }
        }
    }
}
