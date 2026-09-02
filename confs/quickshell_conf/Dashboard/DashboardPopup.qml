import QtQuick
import Quickshell
import "../"
import "Performance"
import "Wallpaper"

PopupWindow {
    id: popup
    property Item anchorItem
    signal closed()

    property string view: "menu" // "menu" | "wallpapers" | "performance"

    anchor.item: anchorItem
    anchor.rect.x: 0
    anchor.rect.y: anchorItem ? anchorItem.height : 0
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom

    color: Colors.surface

    implicitWidth: view === "wallpapers" ? 654 : 340
    implicitHeight: {
        if (view === "menu") return 60;
        const loadedHeight = contentLoader.item ? (contentLoader.item.implicitHeight || contentLoader.item.height) : 0;
        return loadedHeight + 72; // 36px (buttons) + 12px (spacing) + 24px (top/bottom margins)
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
            width: parent.width
            height: 36
            spacing: 12

            // Wallpapers Button
            Rectangle {
                width: (parent.width - 12) / 2
                height: parent.height
                radius: 8
                color: popup.view === "wallpapers" 
                    ? Colors.primary 
                    : (wallpaperMouse.containsMouse ? Colors.surfaceContainerHigh : Colors.surfaceContainer)

                Row {
                    anchors.centerIn: parent
                    spacing: 8

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "\uf03e"
                        font.family: "Font Awesome 7 Free"
                        font.weight: Font.Black
                        font.pixelSize: 13
                        color: popup.view === "wallpapers" ? Colors.onPrimary : Colors.foreground
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Wallpapers"
                        font.bold: true
                        font.pixelSize: 12
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
                width: (parent.width - 12) / 2
                height: parent.height
                radius: 8
                color: popup.view === "performance" 
                    ? Colors.primary 
                    : (perfMouse.containsMouse ? Colors.surfaceContainerHigh : Colors.surfaceContainer)

                Row {
                    anchors.centerIn: parent
                    spacing: 8

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "\uf080"
                        font.family: "Font Awesome 7 Free"
                        font.weight: Font.Black
                        font.pixelSize: 13
                        color: popup.view === "performance" ? Colors.onPrimary : Colors.foreground
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Performance"
                        font.bold: true
                        font.pixelSize: 12
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
        }

        // --- Active Content Loader (Clips content during window animation) ---
        Item {
            width: parent.width
            height: popup.view === "menu" ? 0 : parent.height - 48
            visible: popup.view !== "menu"
            clip: true // 1. Prevents un-rendered content spillover during scale animations

            Loader {
                id: contentLoader
                anchors.fill: parent
                asynchronous: true // 2. Loads child components off-thread to prevent UI stutter
                sourceComponent: {
                    switch (popup.view) {
                        case "wallpapers": return wallpaperComponent
                        case "performance": return performanceComponent
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
}
