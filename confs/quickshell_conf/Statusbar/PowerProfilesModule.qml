import QtQuick
import Quickshell.Services.UPower

Rectangle {
    id: powerProfilesRoot
    width: 30
    height: 30
    color: "transparent"

    readonly property var icons: ({
        0: "\uf06c", // PowerSaver
        1: "\uf24e", // Balanced
        2: "\uf0e7"  // Performance
    })

    readonly property var order: [PowerProfile.PowerSaver, PowerProfile.Balanced, PowerProfile.Performance]

    Text {
        anchors.centerIn: parent
        color: "gold"
        font.family: "Font Awesome 7 Free"
        font.weight: Font.Black
        font.pixelSize: 15
        text: powerProfilesRoot.icons[PowerProfiles.profile] !== undefined ? powerProfilesRoot.icons[PowerProfiles.profile] : powerProfilesRoot.icons[1]
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            const idx = powerProfilesRoot.order.indexOf(PowerProfiles.profile);
            const next = powerProfilesRoot.order[(idx + 1) % powerProfilesRoot.order.length];
            PowerProfiles.profile = next;
        }
    }
}
