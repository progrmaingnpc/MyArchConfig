import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: walkerLauncher
    width: 30
    height: 30
    color: "transparent"
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
            color: "#FFD700"
            text: "" // Or use an Icon component if you have an icon theme
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // This will trigger the command defined in the Process element
                walkerProcess.startDetached();
            }
        }
    }
}
