import QtQuick
import Quickshell.Io

Rectangle {
    id: memoryRoot
    implicitWidth: label.implicitWidth + 12
    height: 30
    color: "transparent"

    property int pct: 0

    FileView {
        id: memFile
        path: "/proc/meminfo"
    }

    function sample() {
        memFile.reload();
        const lines = memFile.text().split("\n");
        const values = {};
        for (const line of lines) {
            const match = line.match(/^(\w+):\s+(\d+)/);
            if (match) values[match[1]] = Number(match[2]);
        }
        if (values.MemTotal > 0 && values.MemAvailable !== undefined) {
            memoryRoot.pct = Math.round((1 - values.MemAvailable / values.MemTotal) * 100);
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: memoryRoot.sample()
    }

    Text {
        id: label
        anchors.centerIn: parent
        color: "gold"
        text: memoryRoot.pct + "%"
    }
}
