import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import "../"
import "../Notifications"
import "../Power"

PanelWindow {
    id: root
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 40
    color: Colors.surface

    Item {
        anchors.fill: parent
        anchors.margins: 10

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

        PowerModule {
            id: power
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }

        BatteryModule {
            id: battery
            anchors.right: network.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        PowerProfilesModule {
            id: powerProfiles
            anchors.right: power.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        NetworkModule {
            id: network
            anchors.right: powerProfiles.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        AudioModule {
            id: audio
            anchors.right: battery.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        NotificationsModule {
            id: notifications
            anchors.left: clock.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        ClockModule {
            id: clock
            anchors.centerIn: parent
        }

        DashboardModule {
            id: dashboard
            anchors.right: clock.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    NotificationsWindow {
        anchorItem: notifications
        visible: notifications.open
    }

    PowerMenu {
        anchorItem: power
        visible: power.open
    }
}
