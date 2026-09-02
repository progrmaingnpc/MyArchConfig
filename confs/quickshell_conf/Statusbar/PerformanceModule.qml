import QtQuick
import Quickshell
import Quickshell.Io
import "../"
import "../Resources"

Item {
    id: perfRoot
    implicitWidth: row.implicitWidth + 12
    implicitHeight: 30

    // --- state ---
    property int cpuPct: 0
    property int cpuTemp: 0
    property int gpuPct: 0
    property int gpuTemp: 0
    property int memPct: 0
    property real memUsedGB: 0
    property real memTotalGB: 0
    property real diskFreeGB: 0
    property real diskTotalGB: 0
    property real diskUsedGB: 0
    property real swapUsedGB: 0
    property real swapTotalGB: 0
    property var coreLoads: []
    property string uptimeStr: ""

    property real lastTotal: 0
    property real lastIdle: 0
    property var lastCoreTotals: []
    property var lastCoreIdles: []

    property bool popupOpen: false

    // resolved once at startup by cpuTempDetect below
    property string cpuTempPath: ""

    FileView { id: statFile; path: "/proc/stat" }
    FileView { id: memFile; path: "/proc/meminfo" }
    FileView { id: uptimeFile; path: "/proc/uptime" }
    FileView {
        id: cpuTempFile
        path: perfRoot.cpuTempPath
    }

    // Scans /sys/class/thermal/thermal_zone*/type for a known CPU sensor
    // name and prints the matching zone's temp path. Runs once at startup.
    Process {
        id: cpuTempDetect
        command: ["bash", "-c",
            "for f in /sys/class/thermal/thermal_zone*/type; do " +
            "  z=$(dirname \"$f\"); t=$(cat \"$f\" 2>/dev/null); " +
            "  case \"$t\" in " +
            "    x86_pkg_temp|k10temp|coretemp|cpu_thermal|soc_thermal) echo \"$z/temp\"; break;; " +
            "  esac; " +
            "done"
        ]
        stdout: SplitParser {
            onRead: data => {
                const path = data.trim();
                if (path.length > 0)
                    perfRoot.cpuTempPath = path;
                else
                    perfRoot.cpuTempPath = "/sys/class/thermal/thermal_zone0/temp"; // fallback
            }
        }
    }

    Process {
        id: gpuProc
        // NVIDIA only. Swap this out if you're on AMD/Intel.
        command: ["nvidia-smi", "--query-gpu=utilization.gpu,temperature.gpu", "--format=csv,noheader,nounits"]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(",");
                if (parts.length >= 2) {
                    perfRoot.gpuPct = parseInt(parts[0].trim());
                    perfRoot.gpuTemp = parseInt(parts[1].trim());
                }
            }
        }
    }

    Process {
        id: diskProc
        command: ["df", "-B1", "--output=size,avail", "/"]
        stdout: SplitParser {
            onRead: data => {
                const lines = data.trim().split("\n");
                const lastLine = lines[lines.length - 1].trim().split(/\s+/);
                if (lastLine.length >= 2) {
                    const totalBytes = parseFloat(lastLine[0]);
                    const availBytes = parseFloat(lastLine[1]);
                    if (!isNaN(totalBytes) && !isNaN(availBytes)) {
                        // Total minus Available matches dysk/btop usage logic
                        perfRoot.diskUsedGB = (totalBytes - availBytes) / 1000000000;
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        cpuTempDetect.running = true;
    }

    function sampleCpu() {
        statFile.reload();
        const lines = statFile.text().split("\n");

        const overall = lines[0].trim().split(/\s+/).slice(1).map(Number);
        const idle = overall[3] + overall[4];
        const total = overall.reduce((a, b) => a + b, 0);
        if (perfRoot.lastTotal > 0) {
            const totalDelta = total - perfRoot.lastTotal;
            const idleDelta = idle - perfRoot.lastIdle;
            perfRoot.cpuPct = totalDelta > 0 ? Math.round((1 - idleDelta / totalDelta) * 100) : 0;
        }
        perfRoot.lastTotal = total;
        perfRoot.lastIdle = idle;

        const coreLines = lines.filter(l => /^cpu\d+/.test(l));
        const newLoads = [];
        const newTotals = [];
        const newIdles = [];
        for (let i = 0; i < coreLines.length; i++) {
            const p = coreLines[i].trim().split(/\s+/).slice(1).map(Number);
            const cIdle = p[3] + p[4];
            const cTotal = p.reduce((a, b) => a + b, 0);
            let pct = 0;
            if (perfRoot.lastCoreTotals[i] !== undefined) {
                const td = cTotal - perfRoot.lastCoreTotals[i];
                const idd = cIdle - perfRoot.lastCoreIdles[i];
                pct = td > 0 ? Math.round((1 - idd / td) * 100) : 0;
            }
            newLoads.push(pct);
            newTotals.push(cTotal);
            newIdles.push(cIdle);
        }
        perfRoot.coreLoads = newLoads;
        perfRoot.lastCoreTotals = newTotals;
        perfRoot.lastCoreIdles = newIdles;
    }

    function sampleMem() {
        memFile.reload();
        const lines = memFile.text().split("\n");
        const values = {};
        for (const line of lines) {
            const m = line.match(/^(\w+):\s+(\d+)/);
            if (m)
                values[m[1]] = Number(m[2]);
        }
        if (values.MemTotal > 0 && values.MemAvailable !== undefined) {
            perfRoot.memPct = Math.round((1 - values.MemAvailable / values.MemTotal) * 100);
            perfRoot.memTotalGB = values.MemTotal / 1048576;
            perfRoot.memUsedGB = (values.MemTotal - values.MemAvailable) / 1048576;
        }
        if (values.SwapTotal !== undefined) {
            perfRoot.swapTotalGB = values.SwapTotal / 1048576;
            perfRoot.swapUsedGB = (values.SwapTotal - (values.SwapFree || 0)) / 1048576;
        }
    }

    function sampleUptime() {
        uptimeFile.reload();
        const secs = parseFloat(uptimeFile.text().split(" ")[0]);
        const h = Math.floor(secs / 3600);
        const m = Math.floor((secs % 3600) / 60);
        perfRoot.uptimeStr = h + "h " + m + "m";
    }

    function sampleCpuTemp() {
        if (perfRoot.cpuTempPath === "")
            return;
        cpuTempFile.reload();
        const raw = parseInt(cpuTempFile.text().trim());
        if (!isNaN(raw))
            perfRoot.cpuTemp = Math.round(raw / 1000);
    }

    function sampleGpu() {
        if (!gpuProc.running)
            gpuProc.running = true;
    }

    function sampleDisk() {
        if (!diskProc.running)
            diskProc.running = true;
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            perfRoot.sampleCpu();
            perfRoot.sampleMem();
            perfRoot.sampleUptime();
            perfRoot.sampleCpuTemp();
            perfRoot.sampleGpu();
            perfRoot.sampleDisk();
        }
    }

    // --- bar pill ---
    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4
        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.muted
            font.family: "Material Symbols Rounded"
            font.weight: Font.Black
            text: "\ueaa2"
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: hoverTimer.restart()
        onExited: leaveTimer.restart()
    }

    Timer { id: hoverTimer; interval: 200; onTriggered: perfRoot.popupOpen = true }
    Timer { id: leaveTimer; interval: 20; onTriggered: perfRoot.popupOpen = false }

    // --- popup ---
    PerformancePopup {
        id: popup
        visible: perfRoot.popupOpen
        anchorItem: perfRoot

        cpuPct: perfRoot.cpuPct
        cpuTemp: perfRoot.cpuTemp
        gpuPct: perfRoot.gpuPct
        gpuTemp: perfRoot.gpuTemp
        memPct: perfRoot.memPct
        memUsedGB: perfRoot.memUsedGB
        memTotalGB: perfRoot.memTotalGB
        diskUsedGB: perfRoot.diskUsedGB
        diskFreeGB: perfRoot.diskFreeGB
        swapUsedGB: perfRoot.swapUsedGB
        swapTotalGB: perfRoot.swapTotalGB
        coreLoads: perfRoot.coreLoads
        uptimeStr: perfRoot.uptimeStr

        onHoverEntered: leaveTimer.stop()
        onHoverExited: leaveTimer.restart()
    }
}
