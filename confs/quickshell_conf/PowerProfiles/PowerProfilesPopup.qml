import QtQuick
import Quickshell
import Quickshell.Services.UPower
import "../"

PopupWindow {
    id: popup
    property Item anchorItem
    signal hoverEntered
    signal hoverExited

    grabFocus: true

    anchor.item: anchorItem
    anchor.rect.x: anchorItem ? (anchorItem.width - implicitWidth) / 2 : 0
    anchor.rect.y: anchorItem ? anchorItem.height : 0

    color: Colors.surface
    implicitWidth: 40
    implicitHeight: content.implicitHeight + 16

    readonly property var order: [PowerProfile.PowerSaver, PowerProfile.Balanced, PowerProfile.Performance]
    readonly property var icons: ({
        [PowerProfile.PowerSaver]: "\uf06c",
        [PowerProfile.Balanced]: "\uf24e",
        [PowerProfile.Performance]: "\uf0e7"
    })

    property int currentIndex: order.indexOf(PowerProfiles.profile)

    // re-sync currentIndex to whatever's actually active whenever the popup opens
    onVisibleChanged: if (visible) {
        currentIndex = order.indexOf(PowerProfiles.profile)
        forceActiveFocus()
    }

    HoverHandler {
        id: hover
        onHoveredChanged: hover.hovered ? popup.hoverEntered() : popup.hoverExited()
    }

    // catches arrow keys / enter as long as this Item has active focus
    Item {
        anchors.fill: parent
        focus: true

        Keys.onUpPressed: {
            popup.currentIndex = Math.max(0, popup.currentIndex - 1)
            PowerProfiles.profile = popup.order[popup.currentIndex]
        }
        Keys.onDownPressed: {
            popup.currentIndex = Math.min(popup.order.length - 1, popup.currentIndex + 1)
            PowerProfiles.profile = popup.order[popup.currentIndex]
        }
        Keys.onReturnPressed: PowerProfiles.profile = popup.order[popup.currentIndex]
        Keys.onEnterPressed: PowerProfiles.profile = popup.order[popup.currentIndex]

        Rectangle {
            anchors.fill: parent
            radius: 10
            color: Colors.surface

            Column {
                id: content
                anchors.fill: parent
                anchors.margins: 6
                spacing: 4

                Repeater {
                    model: popup.order
                    delegate: Rectangle {
                        width: content.width
                        height: 32
                        radius: 6
                        property bool active: PowerProfiles.profile === modelData
                        property bool keySelected: popup.currentIndex === index
                        color: active ? Colors.primary
                             : keySelected ? Colors.surfaceVariant
                             : (rowMouse.containsMouse ? Colors.surfaceVariant : "transparent")

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            spacing: 8

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: popup.icons[modelData]
                                font.family: "Font Awesome 7 Free"
                                font.weight: Font.Black
                                font.pixelSize: 13
                                color: parent.parent.active ? Colors.surface : Colors.foreground
                            }
                        }

                        MouseArea {
                            id: rowMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                PowerProfiles.profile = modelData
                                popup.currentIndex = index
                            }
                            onEntered: popup.currentIndex = index // mouse hover also moves keyboard selection, keeps both in sync
                        }
                    }
                }
            }
        }
    }
}
