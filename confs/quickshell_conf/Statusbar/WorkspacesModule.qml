import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

Rectangle {
    id: workspacesRoot
    color: "transparent"
    radius: implicitHeight / 2
    implicitWidth: content.implicitWidth + 12
    implicitHeight: content.implicitHeight + 8

    Row {
        id: content
        anchors.centerIn: parent
        spacing: 4

        // Map workspace indices (0-based) to Roman numerals
        property var romanMap: ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"]
        readonly property int activeId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1

        // --- 1. The First 5 Static Workspaces ---
        Repeater {
            model: 5
            Rectangle {
                width: 26
                height: 26
                radius: 13

                // Active: gold bg / black text | Inactive: black bg / gold text
                color: (content.activeId === index + 1) ? "gold" : (workspaceMouseArea.containsMouse ? "white" : "black")

                Text {
                    anchors.centerIn: parent
                    text: content.romanMap[index]
                    color: (content.activeId === index + 1) ? "black" : "gold"
                    font.bold: true
                }

                // Clicking a workspace switches to it via hyprctl
                MouseArea {
                    id: workspaceMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                }
            }
        }

        // --- 2. The Dynamic Overflow Slot (Workspaces 6-10) ---
        Rectangle {
            width: 26
            height: 26
            radius: 13

            // Only visible if active workspace is between 6 and 10
            visible: content.activeId >= 6 && content.activeId <= 10
            color: "gold" // Always gold when visible because it IS the active workspace

            Text {
                anchors.centerIn: parent
                text: visible ? content.romanMap[content.activeId - 1] : ""
                color: "black"
                font.bold: true
            }
        }
    }
}
