import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io
import "../Audio"

Rectangle {
    id: audioRoot
    implicitWidth: row.implicitWidth + 12
    height: 30
    color: "transparent"

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : false
    readonly property int pct: sink && sink.audio ? Math.round(sink.audio.volume * 100) : 0
    readonly property var levelIcons: ["\uf026", "\uf027", "\uf028"]
    readonly property string icon: muted ? "\uf6a9" : levelIcons[Math.min(2, Math.floor(pct / 34))]
    property bool open: false

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4
        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: "gold"
            text: audioRoot.pct + "%"
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: "gold"
            font.family: "Font Awesome 7 Free"
            font.weight: Font.Black
            text: audioRoot.icon
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: audioRoot.open = !audioRoot.open
        onWheel: (wheel) => {
            if (!audioRoot.sink || !audioRoot.sink.audio) return;
            const step = 0.05;
            const delta = wheel.angleDelta.y > 0 ? step : -step;
            audioRoot.sink.audio.volume = Math.max(0, Math.min(1, audioRoot.sink.audio.volume + delta));
        }
    }

    AudioPopup {
        anchorItem: audioRoot
        visible: audioRoot.open
    }
}
