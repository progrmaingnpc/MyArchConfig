import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io
import "../"
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

    Timer {
        id: closeTimer
        interval: 20
        repeat: false
        onTriggered: {
            if (!mouseArea.containsMouse && !popupMouseArea.containsMouse) {
                audioRoot.open = false;
            }
        }
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.foreground
            text: audioRoot.pct + "%"
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: audioRoot.muted ? Colors.primary : Colors.foreground
            font.family: "Font Awesome 7 Free"
            font.weight: Font.Black
            text: audioRoot.icon
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            closeTimer.stop();
            audioRoot.open = true;
        }
        onExited: closeTimer.restart()

        onWheel: (wheel) => {
            if (!audioRoot.sink || !audioRoot.sink.audio) return;
            const step = 0.05;
            const delta = wheel.angleDelta.y > 0 ? step : -step;
            audioRoot.sink.audio.volume = Math.max(0, Math.min(1, audioRoot.sink.audio.volume + delta));
        }
    }

    AudioPopup {
        id: popup
        anchorItem: audioRoot
        visible: audioRoot.open

        MouseArea {
            id: popupMouseArea
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true // Allows clicks to pass through

            onEntered: closeTimer.stop()
            onExited: closeTimer.restart()

            // Pass-through handler for clicks and mouse interactions
            onPressed: (mouse) => { mouse.accepted = false; }
            onReleased: (mouse) => { mouse.accepted = false; }
            onClicked: (mouse) => { mouse.accepted = false; }
            onWheel: (wheel) => { wheel.accepted = false; }
        }
    }
}
