import Quickshell
import QtQuick
import "Statusbar"

ShellRoot {
    FileView {
        path: "~/.local/state/quickshell/generated/colors.json"
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.colors = JSON.parse(text())
    }
    StatusBarWindow {}
}
