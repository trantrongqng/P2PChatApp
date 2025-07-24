import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: window
    visible: true
    width: 400
    height: 600
    title: "Chat App"

    // StackView để chuyển đổi giữa Login và Chat
    StackView {
        id: stackView
    anchors.fill: parent
        initialItem: LoginView {
            stackView: stackView
        }
    }

    Connections {
        target: appController

        function onConnected() {
            stackView.push(Qt.resolvedUrl("ChatView.qml"))
        }
    }
}
