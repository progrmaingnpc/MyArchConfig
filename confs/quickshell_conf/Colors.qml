// Colors.qml
pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property color background: "#1a1b26"
    property color foreground: "#c0caf5"
    property color primary: "#7aa2f7"
    property color accent: "#bb9af7"
    property color surface: "#15161e"
    property color surfaceVariant: "#333333"
    property color outline: "#414868"
    property color muted: "#666666"

    property FileView fileView: FileView {
        path: Quickshell.statePath("generated/quickshell-colors.json")
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            const data = JSON.parse(text())
            if (data.background) root.background = data.background
            if (data.foreground) root.foreground = data.foreground
            if (data.primary) root.primary = data.primary
            if (data.accent) root.accent = data.accent
            if (data.surface) root.surface = data.surface
            if (data.surfaceVariant) root.surfaceVariant = data.surfaceVariant
            if (data.outline) root.outline = data.outline
            if (data.muted) root.muted = data.muted
        }
    }
}
