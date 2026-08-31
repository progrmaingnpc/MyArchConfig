import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import "../"

PopupWindow {
    id: popup

    property var cards: []

    Process {
        id: cardsProcess
        command: ["pactl", "-f", "json", "list", "cards"]
        stdout: StdioCollector { id: cardsCollector }
        onExited: {
            try {
                popup.cards = JSON.parse(cardsCollector.text)
            } catch (e) {
                popup.cards = []
            }
        }
    }

    Process {
        id: setProfileProcess
        onExited: cardsProcess.running = true
    }

    onCurrentTabChanged: {
        if (currentTab === 3) cardsProcess.running = true
    }

    property var anchorItem: null
        anchor.item: anchorItem
        anchor.rect.x: anchorItem ? 0 : 0
        anchor.rect.y: anchorItem ? anchorItem.height : 0
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom

        implicitWidth: 460
        implicitHeight: content.implicitHeight + 20
        color: Colors.background

        readonly property var sink: Pipewire.defaultAudioSink
        readonly property var source: Pipewire.defaultAudioSource

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
            color: Colors.surfaceVariant

            Rectangle {
                width: track.width * bar.vol
                height: track.height
                radius: track.radius
                color: Colors.foreground
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

    component NodeRow: Column {
        property var node: null
        property bool selectable: false
        property bool isDefault: false
        width: parent ? parent.width : 0
        spacing: 2

        Rectangle {
            width: parent.width
            height: 20
            color: (selectable && isDefault) ? Colors.surfaceVariant : "transparent"
            radius: 4

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 4
                text: node ? (node.description || node.name) : ""
                color: Colors.foreground
                font.pixelSize: 11
                elide: Text.ElideRight
                width: parent.width - 50
            }
            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 4
                text: (node && node.audio) ? Math.round(node.audio.volume * 100) + "%" : ""
                color: Colors.foreground
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

        Row {
            width: parent.width
            spacing: 8

            Rectangle {
                width: (parent.width - 8) / 2
                height: 36
                radius: 6
                property bool enabled_: popup.source && popup.source.audio ? !popup.source.audio.muted : false
                color: enabled_ ? Colors.foreground : Colors.background
                border.color: Colors.outline
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    font.family: "Font Awesome 7 Free"
                    font.weight: Font.Black
                    text: "\uf130"
                    color: parent.enabled_ ? Colors.background : Colors.foreground
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
                color: enabled_ ? Colors.foreground : Colors.background
                border.color: Colors.outline
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    font.family: "Font Awesome 7 Free"
                    font.weight: Font.Black
                    text: "\uf028"
                    color: parent.enabled_ ? Colors.background : Colors.foreground
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

        Row {
            width: parent.width
            spacing: 0

            Repeater {
                model: popup.tabNames
                delegate: Rectangle {
                    width: content.width / 5
                    height: 30
                    property bool active: popup.currentTab === index
                    color: active ? Colors.foreground : Colors.background
                    border.color: Colors.outline
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        font.pixelSize: 9
                        color: parent.active ? Colors.background : Colors.foreground
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: popup.currentTab = index
                    }
                }
            }
        }

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

    Component {
        id: configTab
        Column {
            width: content.width
            spacing: 14

            Text { text: "Default Output"; color: Colors.muted; font.pixelSize: 11 }
            Text {
                text: popup.sink ? (popup.sink.description || popup.sink.name) : "none"
                color: Colors.foreground; font.pixelSize: 11; font.bold: true
            }
            Text { text: "Default Input"; color: Colors.muted; font.pixelSize: 11 }
            Text {
                text: popup.source ? (popup.source.description || popup.source.name) : "none"
                color: Colors.foreground; font.pixelSize: 11; font.bold: true
            }

            Rectangle {
                width: parent.width
                height: 30
                radius: 4
                color: Colors.surface
                border.color: Colors.outline
                Text {
                    anchors.centerIn: parent
                    text: "Restart WirePlumber"
                    color: Colors.foreground
                    font.pixelSize: 11
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["systemctl", "--user", "restart", "wireplumber"])
                }
            }

            Text { text: "Device Profiles"; color: Colors.foreground; font.pixelSize: 11; font.bold: true }

            Repeater {
                model: popup.cards
                delegate: Column {
                    width: content.width
                    spacing: 4

                    readonly property string cardName: modelData.name
                    readonly property string cardLabel:
                        (modelData.properties && modelData.properties["device.description"])
                            ? modelData.properties["device.description"]
                            : modelData.name
                    readonly property string activeProfile: modelData.active_profile
                    readonly property var otherProfiles: {
                        let names = []
                        for (const key in modelData.profiles) {
                            if (key === activeProfile) continue
                            if (modelData.profiles[key].available !== false)
                                names.push(key)
                        }
                        return names
                    }

                    property bool dropdownOpen: false

                    Text {
                        text: cardLabel
                        color: Colors.foreground
                        font.pixelSize: 11
                        font.bold: true
                        elide: Text.ElideRight
                        width: parent.width
                    }

                    Rectangle {
                        width: parent.width
                        height: 28
                        radius: 4
                        color: Colors.surface
                        border.color: Colors.outline

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            Text {
                                width: parent.width - 16
                                height: parent.height
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                text: activeProfile || "none"
                                color: Colors.foreground
                                font.pixelSize: 11
                                font.bold: true
                            }
                        }

                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: dropdownOpen ? "▲" : "▼"
                            color: Colors.muted
                            font.pixelSize: 9
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: dropdownOpen = !dropdownOpen
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: 2
                        visible: dropdownOpen
                        height: visible ? implicitHeight : 0
                        clip: true

                        Repeater {
                            model: otherProfiles
                            delegate: Rectangle {
                                width: parent.width
                                height: 26
                                radius: 4
                                color: optionMouse.containsMouse ? Colors.surfaceVariant : Colors.surface
                                border.color: Colors.outline
                                border.width: 1

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: modelData
                                    color: Colors.foreground
                                    font.pixelSize: 10
                                }

                                MouseArea {
                                    id: optionMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: {
                                        setProfileProcess.command = ["pactl", "set-card-profile", cardName, modelData]
                                        setProfileProcess.running = true
                                        dropdownOpen = false
                                    }
                                }
                            }
                        }

                        Text {
                            visible: otherProfiles.length === 0
                            text: "No other profiles available"
                            color: Colors.muted
                            font.pixelSize: 9
                        }
                    }
                }
            }

            Text {
                visible: popup.cards.length === 0
                text: "No cards found (is pactl / pipewire-pulse installed?)"
                color: Colors.muted
                font.pixelSize: 10
            }
        }
    }

    Component {
        id: graphTab
        Item {
            id: graphRoot
            width: content.width
            height: 260
            clip: true

            property var nodeItems: ({})

            Rectangle { anchors.fill: parent; color: Colors.surface; radius: 6 }

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
                    color: Colors.outline
                    opacity: 0.6
                    x: visible ? srcItem.x + srcItem.width / 2 : 0
                    y: visible ? srcItem.y + srcItem.height / 2 : 0
                    width: visible ? Math.hypot(dstItem.x - srcItem.x, dstItem.y - srcItem.y) : 0
                    transformOrigin: Item.Left
                    rotation: visible ? Math.atan2(dstItem.y - srcItem.y, dstItem.x - srcItem.x) * 180 / Math.PI : 0
                }
            }

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
                    color: Colors.surface
                    border.color: Colors.outline
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
                        color: Colors.foreground
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
