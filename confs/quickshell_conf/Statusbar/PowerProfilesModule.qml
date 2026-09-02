import QtQuick
import Quickshell.Services.UPower
import "../"
import "../PowerProfiles"

Rectangle {
    id: powerProfilesRoot
    width: 30
    height: 30
    color: "transparent"

    readonly property var icons: ({
        0: "\uf06c",
        1: "\uf24e",
        2: "\uf0e7"
    })
    readonly property var order: [PowerProfile.PowerSaver, PowerProfile.Balanced, PowerProfile.Performance]

    property bool hoveringIcon: false
    property bool hoveringPopup: false
    property bool popupOpen: false

    function refreshOpenState() {
        if (hoveringIcon || hoveringPopup) {
            closeTimer.stop()
            popupOpen = true
        } else {
            closeTimer.restart()
        }
    }

    onHoveringIconChanged: refreshOpenState()
    onHoveringPopupChanged: refreshOpenState()

    Timer {
        id: closeTimer
        interval: 30
        onTriggered: powerProfilesRoot.popupOpen = false
    }

    Text {
        anchors.centerIn: parent
        color: Colors.foreground
        font.family: "Font Awesome 7 Free"
        font.weight: Font.Black
        font.pixelSize: 15
        text: powerProfilesRoot.icons[PowerProfiles.profile] !== undefined ? powerProfilesRoot.icons[PowerProfiles.profile] : powerProfilesRoot.icons[1]
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            const idx = powerProfilesRoot.order.indexOf(PowerProfiles.profile);
            const next = powerProfilesRoot.order[(idx + 1) % powerProfilesRoot.order.length];
            PowerProfiles.profile = next;
        }
        onEntered: powerProfilesRoot.hoveringIcon = true
        onExited: powerProfilesRoot.hoveringIcon = false
    }

    PowerProfilesPopup {
        anchorItem: powerProfilesRoot
        visible: powerProfilesRoot.popupOpen

        onHoverEntered: powerProfilesRoot.hoveringPopup = true
        onHoverExited: powerProfilesRoot.hoveringPopup = false
    }
}
