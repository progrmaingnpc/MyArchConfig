import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

PopupWindow {
    id: popup

    property var anchorItem: null
        anchor.item: anchorItem
        anchor.rect.x: anchorItem ? 0 : 0
        anchor.rect.y: anchorItem ? anchorItem.height : 0
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom

        implicitWidth: 460
        implicitHeight: content.implicitHeight + 20
        color: "black"

        readonly property var sink: Pipewire.defaultAudioSink
        readonly property var source: Pipewire.defaultAudioSource

        // every node that has audio properties — needs to be bound before
        // .audio.muted / .audio.volume can be read or written on it
        readonly property var audioNodes: {
            let n = []
            for (let i = 0; i < Pipewire.nodes.values.length; i++) {
                const node = Pipewire.nodes.values[i]
                if (node.audio) n.push(node)
            }
            return n
        }

        PwObjectTracker {
            objects: popup.audioNodes
        }

        property int currentTab: 0
        readonly property var tabNames: ["Apps", "Nodes", "Inputs", "Configuration", "Graph"]

    // ---------- Draggable volume bar: click-and-hold anywhere to scrub ----------
    component VolumeBar: Item {
        id: bar
        property var node: null
        height: 14
        width: parent ? parent.width : 0

        readonly property real vol: (node && node.audio) ? Math.min(1, node.audio.volume) : 0

        Rectangle {
            id: track
            anchors.fill: parent
            radius: height / 2
            color: "#333333"

            Rectangle {
                width: track.width * bar.vol
                height: track.height
                radius: track.radius
                color: "yellow"
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton

            function setFromX(x) {
                if (!bar.node || !bar.node.audio) return
                const v = Math.max(0, Math.min(1, x / width))
                bar.node.audio.volume = v
            }

            onPressed: (mouse) => setFromX(mouse.x)
            onPositionChanged: (mouse) => {
                if (pressed) setFromX(mouse.x)
            }
        }
    }

    // ---------- Reusable row: name + % + volume bar, optional "select as default" ----------
    component NodeRow: Column {
        property var node: null
        property bool selectable: false
        property bool isDefault: false
        width: parent ? parent.width : 0
        spacing: 2

        Rectangle {
            width: parent.width
            height: 20
            color: (selectable && isDefault) ? "#333333" : "transparent"
            radius: 4

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 4
                text: node ? (node.description || node.name) : ""
                color: "gold"
                font.pixelSize: 11
                elide: Text.ElideRight
                width: parent.width - 50
            }
            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 4
                text: (node && node.audio) ? Math.round(node.audio.volume * 100) + "%" : ""
                color: "gold"
                font.pixelSize: 11
            }

            MouseArea {
                anchors.fill: parent
                visible: selectable
                enabled: selectable
                onClicked: {
                    if (node.isSink)
                        Pipewire.preferredDefaultAudioSink = node
                    else
                        Pipewire.preferredDefaultAudioSource = node
                }
            }
        }

        VolumeBar { node: parent.node }
    }

    Column {
        id: content
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // ---------- Row 1: mic / speaker enable toggles ----------
        Row {
            width: parent.width
            spacing: 8

            Rectangle {
                width: (parent.width - 8) / 2
                height: 36
                radius: 6
                property bool enabled_: popup.source && popup.source.audio ? !popup.source.audio.muted : false
                color: enabled_ ? "gold" : "black"
                border.color: "gold"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    font.family: "Font Awesome 7 Free"
                    font.weight: Font.Black
                    text: "\uf130"
                    color: parent.enabled_ ? "black" : "gold"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (popup.source && popup.source.audio)
                            popup.source.audio.muted = !popup.source.audio.muted
                    }
                }
            }

            Rectangle {
                width: (parent.width - 8) / 2
                height: 36
                radius: 6
                property bool enabled_: popup.sink && popup.sink.audio ? !popup.sink.audio.muted : false
                color: enabled_ ? "gold" : "black"
                border.color: "gold"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    font.family: "Font Awesome 7 Free"
                    font.weight: Font.Black
                    text: "\uf028"
                    color: parent.enabled_ ? "black" : "gold"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (popup.sink && popup.sink.audio)
                            popup.sink.audio.muted = !popup.sink.audio.muted
                    }
                }
            }
        }

        // ---------- Row 2: 5-way segmented tab bar ----------
        Row {
            width: parent.width
            spacing: 0

            Repeater {
                model: popup.tabNames
                delegate: Rectangle {
                    width: content.width / 5
                    height: 30
                    property bool active: popup.currentTab === index
                    color: active ? "gold" : "black"
                    border.color: "gold"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        font.pixelSize: 9
                        color: parent.active ? "black" : "gold"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: popup.currentTab = index
                    }
                }
            }
        }

        // ---------- Tab content ----------
        Loader {
            width: parent.width
            sourceComponent: {
                switch (popup.currentTab) {
                    case 0: return appsTab
                    case 1: return nodesTab
                    case 2: return inputsTab
                    case 3: return configTab
                    case 4: return graphTab
                }
            }
        }
    }

    // ---------- 1. Apps: playback stream volume control ----------
    Component {
        id: appsTab
        Column {
            width: content.width
            spacing: 10
            Repeater {
                model: {
                    let streams = []
                    for (let i = 0; i < Pipewire.nodes.values.length; i++) {
                        const n = Pipewire.nodes.values[i]
                        if (n.isStream && !n.isSink && n.audio) streams.push(n)
                    }
                    return streams
                }
                delegate: NodeRow { node: modelData; selectable: false }
            }
        }
    }

    // ---------- 2. Nodes: audio output (sink) device volume control ----------
    Component {
        id: nodesTab
        Column {
            width: content.width
            spacing: 10
            Repeater {
                model: {
                    let sinks = []
                    for (let i = 0; i < Pipewire.nodes.values.length; i++) {
                        const n = Pipewire.nodes.values[i]
                        if (!n.isStream && n.isSink && n.audio) sinks.push(n)
                    }
                    return sinks
                }
                delegate: NodeRow {
                    node: modelData
                    selectable: true
                    isDefault: popup.sink && modelData.id === popup.sink.id
                }
            }
        }
    }

    // ---------- 3. Inputs: audio input (source) device volume control ----------
    Component {
        id: inputsTab
        Column {
            width: content.width
            spacing: 10
            Repeater {
                model: {
                    let sources = []
                    for (let i = 0; i < Pipewire.nodes.values.length; i++) {
                        const n = Pipewire.nodes.values[i]
                        if (!n.isStream && !n.isSink && n.audio) sources.push(n)
                    }
                    return sources
                }
                delegate: NodeRow {
                    node: modelData
                    selectable: true
                    isDefault: popup.source && modelData.id === popup.source.id
                }
            }
        }
    }

    // ---------- 4. Configuration ----------
    Component {
        id: configTab
        Column {
            width: content.width
            spacing: 8

            Text { text: "Default Output"; color: "gold"; font.pixelSize: 11 }
            Text {
                text: popup.sink ? (popup.sink.description || popup.sink.name) : "none"
                color: "gold"; font.pixelSize: 11; font.bold: true
            }
            Text { text: "Default Input"; color: "gold"; font.pixelSize: 11 }
            Text {
                text: popup.source ? (popup.source.description || popup.source.name) : "none"
                color: "gold"; font.pixelSize: 11; font.bold: true
            }

            Rectangle {
                width: parent.width
                height: 30
                radius: 4
                color: "black"
                border.color: "gold"
                Text {
                    anchors.centerIn: parent
                    text: "Restart WirePlumber"
                    color: "gold"
                    font.pixelSize: 11
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["systemctl", "--user", "restart", "wireplumber"])
                }
            }
        }
    }

    // ---------- 5. Graph: draggable PipeWire node graph ----------
    Component {
        id: graphTab
        Item {
            id: graphRoot
            width: content.width
            height: 260
            clip: true

            property var nodeItems: ({})

            Rectangle { anchors.fill: parent; color: "#111111"; radius: 6 }

            // links
            Repeater {
                model: {
                    let l = []
                    for (let i = 0; i < Pipewire.linkGroups.values.length; i++)
                        l.push(Pipewire.linkGroups.values[i])
                    return l
                }
                delegate: Rectangle {
                    property var srcItem: graphRoot.nodeItems[modelData.source.id]
                    property var dstItem: graphRoot.nodeItems[modelData.target.id]
                    visible: !!srcItem && !!dstItem
                    height: 2
                    color: "gold"
                    opacity: 0.6
                    x: visible ? srcItem.x + srcItem.width / 2 : 0
                    y: visible ? srcItem.y + srcItem.height / 2 : 0
                    width: visible ? Math.hypot(dstItem.x - srcItem.x, dstItem.y - srcItem.y) : 0
                    transformOrigin: Item.Left
                    rotation: visible ? Math.atan2(dstItem.y - srcItem.y, dstItem.x - srcItem.x) * 180 / Math.PI : 0
                }
            }

            // nodes
            Repeater {
                model: {
                    let n = []
                    for (let i = 0; i < Pipewire.nodes.values.length; i++) {
                        const node = Pipewire.nodes.values[i]
                        if (node.audio) n.push(node)
                    }
                    return n
                }
                delegate: Rectangle {
                    id: nodeBox
                    width: 100
                    height: 26
                    radius: 4
                    color: "black"
                    border.color: "gold"
                    border.width: 1

                    Component.onCompleted: {
                        const col = modelData.isStream ? 1 : (modelData.isSink ? 2 : 0)
                        x = 10 + col * 140
                        y = 10 + (index % 8) * 32
                        graphRoot.nodeItems[modelData.id] = nodeBox
                    }

                    Text {
                        anchors.centerIn: parent
                        text: (modelData.description || modelData.name).slice(0, 15)
                        color: "gold"
                        font.pixelSize: 9
                        elide: Text.ElideRight
                        width: parent.width - 6
                        horizontalAlignment: Text.AlignHCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        drag.target: nodeBox
                        drag.axis: Drag.XAndYAxis
                    }
                }
            }
        }
    }
}
