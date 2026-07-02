import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import "../Calender"
import "../Notifications"
import "../Power"
import "../Network"

PanelWindow {
    id: root
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 30
    color: "black"

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

        WallpaperModule {
            id: wallpaper
            anchors.right: clock.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        ClockModule {
            id: clock
            anchors.centerIn: parent
        }

        NotifiationsModule {
            id: notifications
            anchors.left: clock.right
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
            anchors.right: power.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        NetworkModule {
            id: network
            anchors.right: battery.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        AudioModule {
            id: audio
            anchors.right: network.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        MemoryModule {
            id: memory
            anchors.right: audio.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        CpuModule {
            id: cpu
            anchors.right: memory.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    CalendarWindow {
        anchor.item: clock
        visible: clock.hovered
    }

    NotificationsWindow {
        anchorItem: notifications
        visible: notifications.open
    }

    PowerMenu {
        anchorItem: power
        visible: power.open
    }

    NetworkPopup {
        anchorItem: network
        visible: network.open
    }
}
