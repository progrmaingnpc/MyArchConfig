import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    id: cpuRoot
    implicitWidth: row.implicitWidth + 12
    height: 30
    color: "transparent"

    property int pct: 0
    property real lastTotal: 0
    property real lastIdle: 0

    FileView {
        id: statFile
        path: "/proc/stat"
    }

    function sample() {
        statFile.reload();
        const line = statFile.text().split("\n")[0];
        const parts = line.trim().split(/\s+/).slice(1).map(Number);
        const idle = parts[3] + parts[4];
        const total = parts.reduce((a, b) => a + b, 0);
        if (cpuRoot.lastTotal > 0) {
            const totalDelta = total - cpuRoot.lastTotal;
            const idleDelta = idle - cpuRoot.lastIdle;
            cpuRoot.pct = totalDelta > 0 ? Math.round((1 - idleDelta / totalDelta) * 100) : 0;
        }
        cpuRoot.lastTotal = total;
        cpuRoot.lastIdle = idle;
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: cpuRoot.sample()
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: "gold"
            text: cpuRoot.pct + "%"
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: "gold"
            font.family: "Font Awesome 7 Free"
            font.weight: Font.Black
            text: "\uf2db"
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["kitty", "-e", "btop"])
    }
}
