import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import "../"

Rectangle {
    id: workspacesRoot
    radius: implicitHeight / 2
    implicitWidth: content.implicitWidth + 12
    implicitHeight: content.implicitHeight + 8
    color: Colors.surfaceContainerLow
    border.color: Colors.outlineVariant
    border.width: 1

    Row {
        id: content
        anchors.centerIn: parent
        spacing: 4

        property var romanMap: ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"]
        readonly property int activeId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1

        Repeater {
            model: 5
            Rectangle {
                width: 32
                height: 26
                radius: 13
                color: (content.activeId === index + 1) ? Colors.primary : (workspaceMouseArea.containsMouse ? Colors.surfaceVariant : Colors.surface)

                Text {
                    font.family: "Cinzel"
                    font.bold: true
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    anchors.centerIn: parent
                    text: content.romanMap[index]
                    color: (content.activeId === index + 1) ? Colors.surface : Colors.foreground
                }

                MouseArea {
                    id: workspaceMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Hyprland.dispatch('hl.dsp.focus({ workspace = "' + (index + 1) + '" })')
                }
            }
        }

        Rectangle {
            width: 32
            height: 26
            radius: 13
            visible: content.activeId >= 6 && content.activeId <= 10
            color: Colors.primary

            Text {
                font.family: "Cinzel"
                font.bold: true
                font.pixelSize: 14
                font.weight: Font.DemiBold
                anchors.centerIn: parent
                text: visible ? content.romanMap[content.activeId - 1] : ""
                color: Colors.surface
            }
        }
    }
}
