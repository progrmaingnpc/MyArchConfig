import QtQuick
import Quickshell
import Quickshell.Networking
import Quickshell.Bluetooth
import Quickshell.Io

PopupWindow {
    id: root
    color: "black"

    property Item anchorItem

    anchor.item: anchorItem
    anchor.edges: Edges.Bottom | Edges.Right
    anchor.gravity: Edges.Bottom | Edges.Left
    anchor.margins.top: 8

    implicitWidth: 340
    implicitHeight: Math.min(560, Math.max(160, content.implicitHeight + 20))

    readonly property var devices: Networking.devices ? Networking.devices.values : []
    readonly property var wifiDevice: devices.find(d => d.type === DeviceType.Wifi)
    readonly property var wiredDevice: devices.find(d => d.type === DeviceType.Wired)
    readonly property var networks: wifiDevice
        ? wifiDevice.networks.values.slice().sort((a, b) => b.signalStrength - a.signalStrength)
        : []

    property bool networkingEnabled: true
    property var vpnConnections: []

    property var pendingNetwork: null
    property string pskInput: ""

    property bool hiddenFormOpen: false
    property string hiddenSsid: ""
    property string hiddenPsk: ""

    property bool hotspotFormOpen: false
    property string hotspotName: ""
    property string hotspotPsk: ""

    onVisibleChanged: {
        if (visible) {
            if (wifiDevice) {
                wifiDevice.scannerEnabled = true;
                rescanProcess.command = ["nmcli", "device", "wifi", "rescan", "ifname", wifiDevice.name];
                rescanProcess.startDetached();
            }
            networkingStateProcess.running = true;
            vpnListProcess.running = true;
        } else {
            pendingNetwork = null;
            pskInput = "";
            hiddenFormOpen = false;
            hotspotFormOpen = false;
        }
    }

    Process {
        id: networkingStateProcess
        command: ["nmcli", "networking"]
        stdout: StdioCollector { id: networkingStateCollector }
        onExited: root.networkingEnabled = networkingStateCollector.text.trim() === "enabled"
    }

    Process { id: networkingToggleProcess }

    Process {
        id: vpnListProcess
        command: ["nmcli", "-t", "-f", "NAME,TYPE,ACTIVE", "connection", "show"]
        stdout: StdioCollector { id: vpnListCollector }
        onExited: {
            const lines = vpnListCollector.text.trim().split("\n").filter(l => l.length > 0);
            const vpns = [];
            for (const line of lines) {
                const parts = line.split(":");
                if (parts[1] === "vpn" || parts[1] === "wireguard") {
                    vpns.push({ name: parts[0], active: parts[2] === "yes" });
                }
            }
            root.vpnConnections = vpns;
        }
    }

    Process { id: rescanProcess }
    Process { id: vpnToggleProcess }
    Process { id: hiddenConnectProcess }
    Process { id: hotspotProcess }

    Flickable {
        id: flick
        anchors.fill: parent
        anchors.margins: 10
        contentWidth: width
        contentHeight: content.implicitHeight
        clip: true

        Column {
            id: content
            width: flick.width
            spacing: 10

            Row {
                width: parent.width
                spacing: 10

                Rectangle {
                    width: (parent.width - 20) / 3
                    height: 32
                    radius: 6
                    color: Networking.wifiEnabled ? "gold" : "#1a1a1a"

                    Text {
                        anchors.centerIn: parent
                        text: ""
                        color: Networking.wifiEnabled ? "black" : "gold"
                        font.family: "Font Awesome 7 Free"
                        font.weight: Font.Black
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
                    }
                }
                Rectangle {
                    readonly property bool btEnabled: Bluetooth.defaultAdapter !== null && Bluetooth.defaultAdapter.enabled

                    width: (parent.width - 20) / 3
                    height: 32
                    radius: 6
                    color: btEnabled ? "gold" : "#1a1a1a"

                    Text {
                        anchors.centerIn: parent
                        text: "\uf293"
                        color: parent.btEnabled ? "black" : "gold"
                        font.family: "Font Awesome 7 Brands"
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (Bluetooth.defaultAdapter) {
                                Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
                            }
                        }
                    }
                }
                Rectangle {
                    width: (parent.width - 20) / 3
                    height: 32
                    radius: 6
                    color: root.networkingEnabled ? "gold" : "#1a1a1a"

                    Text {
                        anchors.centerIn: parent
                        text: ""
                        color: root.networkingEnabled ? "black" : "gold"
                        font.family: "Font Awesome 7 Free"
                        font.weight: Font.Black
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            const enable = !root.networkingEnabled;
                            networkingToggleProcess.command = ["nmcli", "networking", enable ? "on" : "off"];
                            networkingToggleProcess.startDetached();
                            root.networkingEnabled = enable;
                        }
                    }
                }
            }

            Column {
                width: parent.width
                spacing: 4
                visible: root.wiredDevice !== undefined

                Text { text: "Ethernet"; color: "gold"; font.bold: true; font.pixelSize: 11 }

                Rectangle {
                    width: parent.width
                    height: 36
                    radius: 6
                    color: root.wiredDevice && root.wiredDevice.connected ? "gold" : "#1a1a1a"

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 8

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 90
                            elide: Text.ElideRight
                            text: root.wiredDevice ? root.wiredDevice.name : ""
                            color: root.wiredDevice && root.wiredDevice.connected ? "black" : "gold"
                            font.bold: !!(root.wiredDevice && root.wiredDevice.connected)
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: root.wiredDevice && root.wiredDevice.connected ? "Disconnect" : "Connect"
                            color: root.wiredDevice && root.wiredDevice.connected ? "black" : "gold"
                            font.pixelSize: 10
                            font.bold: true
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (!root.wiredDevice) return;
                            if (root.wiredDevice.connected) {
                                root.wiredDevice.disconnect();
                            } else if (root.wiredDevice.network) {
                                root.wiredDevice.network.connect();
                            }
                        }
                    }
                }
            }

            Column {
                width: parent.width
                spacing: 4
                visible: root.wifiDevice !== undefined

                Text { text: "Wi-Fi Networks"; color: "gold"; font.bold: true; font.pixelSize: 11 }

                Repeater {
                    model: root.networks

                    delegate: Column {
                        width: content.width
                        spacing: 4

                        Rectangle {
                            width: parent.width
                            height: 36
                            radius: 6
                            color: modelData.connected ? "gold" : "#1a1a1a"

                            Row {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 8

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 34
                                    text: Math.round(modelData.signalStrength * 100) + "%"
                                    color: modelData.connected ? "black" : "gold"
                                }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - 140
                                    elide: Text.ElideRight
                                    text: modelData.name
                                    color: modelData.connected ? "black" : "gold"
                                    font.bold: modelData.connected
                                }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: modelData.connected ? "Disconnect" : ""
                                    color: "black"
                                    font.pixelSize: 10
                                    font.bold: true
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (modelData.connected) {
                                        modelData.disconnect();
                                    } else if (modelData.known || modelData.security === WifiSecurityType.Open) {
                                        modelData.connect();
                                    } else {
                                        root.pendingNetwork = modelData;
                                        root.pskInput = "";
                                    }
                                }
                            }
                        }

                        Row {
                            visible: root.pendingNetwork === modelData
                            width: parent.width
                            height: visible ? 32 : 0
                            spacing: 6

                            Rectangle {
                                width: parent.width - 70
                                height: 32
                                radius: 6
                                color: "#1a1a1a"

                                TextInput {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    color: "gold"
                                    echoMode: TextInput.Password
                                    focus: root.pendingNetwork === modelData
                                    text: root.pskInput
                                    onTextChanged: root.pskInput = text
                                    onAccepted: {
                                        modelData.connectWithPsk(root.pskInput);
                                        root.pendingNetwork = null;
                                    }
                                }
                            }

                            Rectangle {
                                width: 60
                                height: 32
                                radius: 6
                                color: "gold"

                                Text {
                                    anchors.centerIn: parent
                                    text: "Connect"
                                    font.pixelSize: 10
                                    font.bold: true
                                    color: "black"
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        modelData.connectWithPsk(root.pskInput);
                                        root.pendingNetwork = null;
                                    }
                                }
                            }
                        }
                    }
                }

                Text {
                    visible: root.wifiDevice !== undefined && root.networks.length === 0
                    text: "No WiFi networks found"
                    color: "gold"
                }

                Rectangle {
                    width: parent.width
                    height: 32
                    radius: 6
                    color: "#1a1a1a"

                    Text {
                        anchors.centerIn: parent
                        text: "Connect to Hidden Network..."
                        color: "gold"
                        font.pixelSize: 11
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.hiddenFormOpen = !root.hiddenFormOpen;
                            root.hotspotFormOpen = false;
                        }
                    }
                }

                Column {
                    visible: root.hiddenFormOpen
                    width: parent.width
                    spacing: 6

                    Rectangle {
                        width: parent.width
                        height: 32
                        radius: 6
                        color: "#1a1a1a"

                        TextInput {
                            anchors.fill: parent
                            anchors.margins: 8
                            color: "gold"
                            text: root.hiddenSsid
                            onTextChanged: root.hiddenSsid = text
                        }

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Network name"
                            color: "#666666"
                            visible: root.hiddenSsid.length === 0
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 32
                        radius: 6
                        color: "#1a1a1a"

                        TextInput {
                            anchors.fill: parent
                            anchors.margins: 8
                            color: "gold"
                            echoMode: TextInput.Password
                            text: root.hiddenPsk
                            onTextChanged: root.hiddenPsk = text
                        }

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Password (blank if open)"
                            color: "#666666"
                            visible: root.hiddenPsk.length === 0
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 32
                        radius: 6
                        color: "gold"

                        Text { anchors.centerIn: parent; text: "Connect"; font.bold: true; color: "black" }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                const args = ["nmcli", "device", "wifi", "connect", root.hiddenSsid, "hidden", "yes"];
                                if (root.hiddenPsk.length > 0) {
                                    args.push("password");
                                    args.push(root.hiddenPsk);
                                }
                                hiddenConnectProcess.command = args;
                                hiddenConnectProcess.startDetached();
                                root.hiddenFormOpen = false;
                                root.hiddenSsid = "";
                                root.hiddenPsk = "";
                            }
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 32
                    radius: 6
                    color: "#1a1a1a"

                    Text {
                        anchors.centerIn: parent
                        text: "Create New Wi-Fi Network..."
                        color: "gold"
                        font.pixelSize: 11
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.hotspotFormOpen = !root.hotspotFormOpen;
                            root.hiddenFormOpen = false;
                        }
                    }
                }

                Column {
                    visible: root.hotspotFormOpen
                    width: parent.width
                    spacing: 6

                    Rectangle {
                        width: parent.width
                        height: 32
                        radius: 6
                        color: "#1a1a1a"

                        TextInput {
                            anchors.fill: parent
                            anchors.margins: 8
                            color: "gold"
                            text: root.hotspotName
                            onTextChanged: root.hotspotName = text
                        }

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Hotspot name"
                            color: "#666666"
                            visible: root.hotspotName.length === 0
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 32
                        radius: 6
                        color: "#1a1a1a"

                        TextInput {
                            anchors.fill: parent
                            anchors.margins: 8
                            color: "gold"
                            echoMode: TextInput.Password
                            text: root.hotspotPsk
                            onTextChanged: root.hotspotPsk = text
                        }

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Password (min 8 chars)"
                            color: "#666666"
                            visible: root.hotspotPsk.length === 0
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 32
                        radius: 6
                        color: "gold"

                        Text { anchors.centerIn: parent; text: "Create"; font.bold: true; color: "black" }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (!root.wifiDevice) return;
                                hotspotProcess.command = ["nmcli", "device", "wifi", "hotspot", "ifname", root.wifiDevice.name, "ssid", root.hotspotName, "password", root.hotspotPsk];
                                hotspotProcess.startDetached();
                                root.hotspotFormOpen = false;
                                root.hotspotName = "";
                                root.hotspotPsk = "";
                            }
                        }
                    }
                }
            }

            Column {
                width: parent.width
                spacing: 4
                visible: root.vpnConnections.length > 0

                Text { text: "VPN Connections"; color: "gold"; font.bold: true; font.pixelSize: 11 }

                Repeater {
                    model: root.vpnConnections

                    delegate: Rectangle {
                        width: content.width
                        height: 36
                        radius: 6
                        color: modelData.active ? "gold" : "#1a1a1a"

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            spacing: 8

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 90
                                elide: Text.ElideRight
                                text: modelData.name
                                color: modelData.active ? "black" : "gold"
                                font.bold: modelData.active
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.active ? "Disconnect" : "Connect"
                                color: modelData.active ? "black" : "gold"
                                font.pixelSize: 10
                                font.bold: true
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                vpnToggleProcess.command = ["nmcli", "connection", modelData.active ? "down" : "up", modelData.name];
                                vpnToggleProcess.startDetached();
                                vpnListProcess.running = true;
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 32
                radius: 6
                color: "#1a1a1a"

                Text {
                    anchors.centerIn: parent
                    text: "Bluetooth"
                    color: "gold"
                    font.pixelSize: 11
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["blueman-manager"])
                }
            }

            Row {
                width: parent.width
                spacing: 10

                Rectangle {
                    width: (parent.width - 10) / 2
                    height: 32
                    radius: 6
                    color: "#1a1a1a"

                    Text {
                        anchors.centerIn: parent
                        text: "Connection Info"
                        color: "gold"
                        font.pixelSize: 11
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            const dev = (root.wifiDevice && root.wifiDevice.connected)
                                ? root.wifiDevice.name
                                : (root.wiredDevice ? root.wiredDevice.name : "");
                            if (dev.length === 0) return;
                            Quickshell.execDetached(["kitty", "--hold", "-e", "nmcli", "device", "show", dev]);
                        }
                    }
                }

                Rectangle {
                    width: (parent.width - 10) / 2
                    height: 32
                    radius: 6
                    color: "#1a1a1a"

                    Text {
                        anchors.centerIn: parent
                        text: "Edit Connections"
                        color: "gold"
                        font.pixelSize: 11
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Quickshell.execDetached(["nm-connection-editor"])
                    }
                }
            }
        }
    }
}
