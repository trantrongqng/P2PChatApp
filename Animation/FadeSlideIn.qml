import QtQuick 2.15

Item {
    id: fadeSlide
    property Item target
    property int duration: 600
    property int offset: 50
    property bool started: false

    function startAnimation() {
        if (!target || started) return
        started = true

        target.opacity = 0
        target.y += offset

        Qt.callLater(function() {
            if (!target) return

            var anim = Qt.createQmlObject(`
                import QtQuick 2.15
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation { target: fadeSlide.target; property: "opacity"; to: 1; duration: ` + duration + `; easing.type: Easing.InOutQuad }
                        NumberAnimation { target: fadeSlide.target; property: "y"; to: ` + (target.y - offset) + `; duration: ` + duration + `; easing.type: Easing.OutBack }
                    }
                }
            `, fadeSlide, "DynamicAnimation")

            anim.start()
        })
    }

    onTargetChanged: {
        if (target) startAnimation()
    }
}
