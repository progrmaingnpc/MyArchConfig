import QtQuick

Canvas {
    id: pie

    property real value: 0   // 0-100, drives the ring fill
    property color trackColor: "#313244"
    property color valueColor: "#89b4fa"
    property real ringWidth: 8
    property string centerText: ""
    property color textColor: "#cdd6f4"

    onValueChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onTrackColorChanged: requestPaint()
    onValueColorChanged: requestPaint()
    onCenterTextChanged: requestPaint()

    onPaint: {
        const ctx = getContext("2d");
        ctx.reset();

        const cx = width / 2;
        const cy = height / 2;
        const radius = Math.min(width, height) / 2 - ringWidth / 2;
        const startAngle = -Math.PI / 2;
        const clamped = Math.min(Math.max(value, 0), 100);
        const endAngle = startAngle + (Math.PI * 2 * clamped / 100);

        ctx.beginPath();
        ctx.arc(cx, cy, radius, 0, Math.PI * 2);
        ctx.lineWidth = ringWidth;
        ctx.strokeStyle = trackColor;
        ctx.stroke();

        if (clamped > 0) {
            ctx.beginPath();
            ctx.arc(cx, cy, radius, startAngle, endAngle);
            ctx.lineWidth = ringWidth;
            ctx.lineCap = "round";
            ctx.strokeStyle = valueColor;
            ctx.stroke();
        }

        if (centerText.length > 0) {
            ctx.fillStyle = textColor;
            ctx.font = "bold " + Math.round(radius * 0.42) + "px sans-serif";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.fillText(centerText, cx, cy);
        }
    }
}
