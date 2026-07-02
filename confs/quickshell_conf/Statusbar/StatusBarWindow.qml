import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

PanelWindow {
    id: root
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 30
    color: "#000000"

    Item {
        anchors {
            fill: parent
            margins: 8
        }

        LauncherModule {
            id: launcher
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        WorkspacesModule {
            id: workspaces
            anchors.left: launcher.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        ClockModule {
            id: clock
            anchors.centerIn: parent
        }
    }
}
