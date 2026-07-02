import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: walkerLauncher
    width: 30
    height: 30
    radius: 15
    color: launcherMouseArea.containsMouse ? "black" : "black"

    // Optional Process element to run Walker in the background if needed
    Process {
        id: walkerProcess
        // Pass specific walker modules if desired (e.g., ["walker", "--modules", "emojis"])
        command: ["walker"]
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Text {
            color: "gold"
            text: "" // Or use an Icon component if you have an icon theme
            anchors.centerIn: parent
        }

        MouseArea {
            id: launcherMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                // This will trigger the command defined in the Process element
                walkerProcess.startDetached();
            }
        }
    }
}
