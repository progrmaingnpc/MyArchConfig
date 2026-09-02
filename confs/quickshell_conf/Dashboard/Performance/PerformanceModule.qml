import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: perfRoot

    property int cpuPct: 0
    property int cpuTemp: 0
    property int gpuPct: 0
    property int gpuTemp: 0
    property int memPct: 0
    property real memUsedGB: 0
    property real memTotalGB: 0
    property real diskUsedGB: 0
    property real swapUsedGB: 0
    property real swapTotalGB: 0
    property var coreLoads: []
    property string uptimeStr: ""

    property real lastTotal: 0
    property real lastIdle: 0
    property var lastCoreTotals: []
    property var lastCoreIdles: []

    property string cpuTempPath: ""

    FileView { id: statFile; path: "/proc/stat" }
    FileView { id: memFile; path: "/proc/meminfo" }
    FileView { id: uptimeFile; path: "/proc/uptime" }
    FileView { id: cpuTempFile; path: perfRoot.cpuTempPath }

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
                perfRoot.cpuTempPath = path.length > 0 ? path : "/sys/class/thermal/thermal_zone0/temp";
            }
        }
    }

    Process {
        id: gpuProc
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
                        perfRoot.diskUsedGB = (totalBytes - availBytes) / 1000000000;
                    }
                }
            }
        }
    }

    Component.onCompleted: cpuTempDetect.running = true

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
        const newLoads = [], newTotals = [], newIdles = [];
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
            newLoads.push(pct); newTotals.push(cTotal); newIdles.push(cIdle);
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
            if (m) values[m[1]] = Number(m[2]);
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
        if (perfRoot.cpuTempPath === "") return;
        cpuTempFile.reload();
        const raw = parseInt(cpuTempFile.text().trim());
        if (!isNaN(raw)) perfRoot.cpuTemp = Math.round(raw / 1000);
    }

    function sampleGpu() { if (!gpuProc.running) gpuProc.running = true; }
    function sampleDisk() { if (!diskProc.running) diskProc.running = true; }

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
}
