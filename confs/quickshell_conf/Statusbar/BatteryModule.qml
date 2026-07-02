import QtQuick
import Quickshell.Services.UPower

Rectangle {
    id: batteryRoot
    implicitWidth: row.implicitWidth + 12
    height: 30
    color: "transparent"

    readonly property var device: UPower.displayDevice
    readonly property bool ready: device !== null && device.ready && device.isLaptopBattery
    readonly property int pct: ready ? Math.round(device.percentage * 100) : 0
    readonly property bool charging: ready
        && (device.state === UPowerDeviceState.Charging || device.state === UPowerDeviceState.PendingCharge)

    readonly property var levelIcons: ["\uf244", "\uf243", "\uf242", "\uf241", "\uf240"]
    readonly property string icon: charging ? "\uf5e7" : levelIcons[Math.max(0, Math.min(4, Math.floor(pct / 20)))]

    visible: ready

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: "gold"
            text: batteryRoot.pct + "%"
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: "gold"
            font.family: "Font Awesome 7 Free"
            font.weight: Font.Black
            text: batteryRoot.icon
        }
    }
}
