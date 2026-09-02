import QtQuick
import Quickshell
import "../"
import "Performance"
import "Wallpaper"
import "Calendar"

PopupWindow {
    id: popup
    property Item anchorItem
    signal closed()

    property string view: "menu" // "menu" | "wallpapers" | "performance" | "calendar"

    anchor.item: anchorItem
    anchor.rect.x: 0
    anchor.rect.y: anchorItem ? anchorItem.height : 0
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom

    color: Colors.surface

    implicitWidth: {
        if (view === "wallpapers") return 654;
        if (view === "calendar") return 310; // Tightened width for cleaner margins
        return 420;
    }

   implicitHeight: {
        if (view === "menu") return 60;
        const loadedHeight = contentLoader.item ? (contentLoader.item.implicitHeight || contentLoader.item.height) : 0;
        return loadedHeight + 72; // Dynamically wraps whatever size CalendarPopup requests
    }

    Behavior on implicitWidth { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
    Behavior on implicitHeight { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

    onVisibleChanged: if (!visible) popup.view = "menu"

    PerformanceModule {
        id: perfData
    }

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: popup.view === "menu" ? 0 : 12

        // --- Navigation Bar ---
        Row {
            id: navRow
            width: parent.width
            height: 36
            spacing: 6

            // Wallpapers Button
            Rectangle {
                width: (navRow.width - (navRow.spacing * 2)) / 3
                height: parent.height
                radius: 8
                color: popup.view === "wallpapers"
                    ? Colors.primary
                    : (wallpaperMouse.containsMouse ? Colors.surfaceContainerHigh : Colors.surfaceContainer)

                Row {
                    anchors.centerIn: parent
                    spacing: 4

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "\uf03e"
                        font.family: "Font Awesome 7 Free"
                        font.weight: Font.Black
                        font.pixelSize: 11
                        color: popup.view === "wallpapers" ? Colors.onPrimary : Colors.foreground
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Wallpapers"
                        font.bold: true
                        font.pixelSize: 10
                        elide: Text.ElideRight
                        color: popup.view === "wallpapers" ? Colors.onPrimary : Colors.foreground
                    }
                }

                MouseArea {
                    id: wallpaperMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: popup.view = popup.view === "wallpapers" ? "menu" : "wallpapers"
                }
            }

            // Performance Button
            Rectangle {
                width: (navRow.width - (navRow.spacing * 2)) / 3
                height: parent.height
                radius: 8
                color: popup.view === "performance"
                    ? Colors.primary
                    : (perfMouse.containsMouse ? Colors.surfaceContainerHigh : Colors.surfaceContainer)

                Row {
                    anchors.centerIn: parent
                    spacing: 4

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "\uf080"
                        font.family: "Font Awesome 7 Free"
                        font.weight: Font.Black
                        font.pixelSize: 11
                        color: popup.view === "performance" ? Colors.onPrimary : Colors.foreground
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Performance"
                        font.bold: true
                        font.pixelSize: 10
                        elide: Text.ElideRight
                        color: popup.view === "performance" ? Colors.onPrimary : Colors.foreground
                    }
                }

                MouseArea {
                    id: perfMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: popup.view = popup.view === "performance" ? "menu" : "performance"
                }
            }

            // Calendar Button
            Rectangle {
                width: (navRow.width - (navRow.spacing * 2)) / 3
                height: parent.height
                radius: 8
                color: popup.view === "calendar"
                    ? Colors.primary
                    : (calMouse.containsMouse ? Colors.surfaceContainerHigh : Colors.surfaceContainer)

                Row {
                    anchors.centerIn: parent
                    spacing: 4

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "\uf133"
                        font.family: "Font Awesome 7 Free"
                        font.weight: Font.Black
                        font.pixelSize: 11
                        color: popup.view === "calendar" ? Colors.onPrimary : Colors.foreground
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Calendar"
                        font.bold: true
                        font.pixelSize: 10
                        elide: Text.ElideRight
                        color: popup.view === "calendar" ? Colors.onPrimary : Colors.foreground
                    }
                }

                MouseArea {
                    id: calMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: popup.view = popup.view === "calendar" ? "menu" : "calendar"
                }
            }
        }

        // --- Active Content Loader ---
        Item {
            width: parent.width
            height: popup.view === "menu" ? 0 : parent.height - 48
            visible: popup.view !== "menu"

            Loader {
                id: contentLoader
                anchors.fill: parent
                asynchronous: true
                sourceComponent: {
                    switch (popup.view) {
                        case "wallpapers": return wallpaperComponent
                        case "performance": return performanceComponent
                        case "calendar": return calendarComponent
                        default: return null
                    }
                }
            }
        }
    }

    Component {
        id: wallpaperComponent
        WallpaperWindow {
            onWallpaperSelected: popup.closed()
        }
    }

    Component {
        id: performanceComponent
        PerformancePopup {
            cpuPct: perfData.cpuPct
            cpuTemp: perfData.cpuTemp
            gpuPct: perfData.gpuPct
            gpuTemp: perfData.gpuTemp
            memPct: perfData.memPct
            memUsedGB: perfData.memUsedGB
            memTotalGB: perfData.memTotalGB
            diskUsedGB: perfData.diskUsedGB
            swapUsedGB: perfData.swapUsedGB
            swapTotalGB: perfData.swapTotalGB
            coreLoads: perfData.coreLoads
            uptimeStr: perfData.uptimeStr
        }
    }

    Component {
        id: calendarComponent
        CalendarPopup {}
    }
}
