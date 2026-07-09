import QtQuick
import Quickshell
import Quickshell.Io

PopupWindow {
    id: root

    property Item anchorItem
    signal powerOptionSelected()
    anchor.item: anchorItem
    anchor.edges: Edges.Bottom | Edges.Right
    anchor.gravity: Edges.Bottom | Edges.Left
    anchor.margins.top: 8

    color: "black"

    readonly property int buttonSize: 44
    readonly property var actions: [
        { label: "Lock", cmd: "hyprlock" },
        { label: "Suspend", cmd: "hyprshutdown -p 'systemctl suspend'" },
        { label: "Hibernate", cmd: "systemctl hibernate" },
        { label: "Logout", cmd: "hyprshutdown -p 'loginctl terminate-user $USER'" },
        { label: "Reboot", cmd: "hyprshutdown -p 'reboot'" },
        { label: "⏻", cmd: "hyprshutdown -p 'systemctl poweroff'" }
    ]

    implicitWidth: (buttonSize + 8) * actions.length + 12
    implicitHeight: buttonSize + 20

    Process {
        id: actionProcess
    }

    Row {
        anchors.centerIn: parent
        spacing: 8

        Repeater {
            model: root.actions

            Rectangle {
                width: root.buttonSize
                height: root.buttonSize
                radius: width / 2
                color: buttonMouse.containsMouse ? "gold" : "black"

                Text {
                    anchors.centerIn: parent
                    text: modelData.label
                    color: buttonMouse.containsMouse ? "black" : "gold"
                    font.pixelSize: modelData.label.length > 2 ? 9 : 16
                    font.bold: true
                }

                MouseArea {
                    id: buttonMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        actionProcess.command = ["sh", "-c", modelData.cmd];
                        actionProcess.startDetached();
                        root.powerOptionSelected()
                    }
                }
            }
        }
    }
}
