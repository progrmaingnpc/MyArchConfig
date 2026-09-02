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
    property color textOnPrimary: "#1a1b26"
    property color accent: "#bb9af7"
    property color surface: "#15161e"
    property color surfaceContainer: "#1f2335"
    property color surfaceContainerHigh: "#292e42"
    property color surfaceContainerLow: "#16161e"
    property color surfaceVariant: "#333333"
    property color textOnSurfaceVariant: "#a9b1d6"
    property color outline: "#414868"
    property color outlineVariant: "#292e42"
    property color muted: "#666666"

    property FileView fileView: FileView {
        path: Quickshell.statePath("generated/quickshell-colors.json")
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                if (data.background) root.background = data.background;
                if (data.foreground) root.foreground = data.foreground;
                if (data.primary) root.primary = data.primary;
                if (data.onPrimary) root.textOnPrimary = data.onPrimary;
                if (data.accent) root.accent = data.accent;
                if (data.surface) root.surface = data.surface;
                if (data.surfaceContainer) root.surfaceContainer = data.surfaceContainer;
                if (data.surfaceContainerHigh) root.surfaceContainerHigh = data.surfaceContainerHigh;
                if (data.surfaceContainerLow) root.surfaceContainerLow = data.surfaceContainerLow;
                if (data.surfaceVariant) root.surfaceVariant = data.surfaceVariant;
                if (data.onSurfaceVariant) root.textOnSurfaceVariant = data.onSurfaceVariant;
                if (data.outline) root.outline = data.outline;
                if (data.outlineVariant) root.outlineVariant = data.outlineVariant;
                if (data.muted) root.muted = data.muted;
            } catch (e) {
                console.warn("Failed to parse quickshell-colors.json:", e);
            }
        }
    }
}
