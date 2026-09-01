import QtQuick

Canvas {
    id: spark
    property var values: []
    property color lineColor: "#89b4fa"
    property real maxValue: 100

    onValuesChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        const ctx = getContext("2d");
        ctx.reset();
        if (values.length < 2)
            return;
        ctx.strokeStyle = lineColor;
        ctx.lineWidth = 1.5;
        ctx.beginPath();
        const stepX = width / (values.length - 1);
        for (let i = 0; i < values.length; i++) {
            const x = i * stepX;
            const y = height - (values[i] / maxValue) * height;
            if (i === 0)
                ctx.moveTo(x, y);
            else
                ctx.lineTo(x, y);
        }
        ctx.stroke();
    }
}
