import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "JS/Color.js" as Color
import "JS/resource.js" as Res
import "Animation" as Ani

Item {
    id: loginView
   // anchors.fill: parent

    property StackView stackView

    Rectangle {
        anchors.fill: parent

        gradient: Gradient {
            GradientStop { position: 0.0; color: Color.BG_LIGHT }
            GradientStop { position: 1.0; color: Color.BG_DARK }
        }

        Column {
            id: formColumn
            anchors.centerIn: parent
            spacing: 20
            width: 300

            // Avatar
            Rectangle {
                width: 80
                height: 80
                radius: 40
                color: "#e0e0e0"
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    source: Res.AVATAR
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                }
            }

            // Username
            TextField {
                id: usernameField
                width: parent.width
                placeholderText: "Tên người dùng / Email"
                leftPadding: 30
                font.pixelSize: 16
                background: Rectangle {
                    color: Color.WHITE
                    radius: 4
                    height: 40
                }

                Image {
                    source: Res.ICON_USER
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    width: 18
                    height: 18
                }
            }

            // Password ẩn hiện
            TextField {
                id: passwordField
                width: parent.width
                placeholderText: "Mật khẩu"
                echoMode: TextInput.Password
                leftPadding: 30
                font.pixelSize: 16

                background: Rectangle {
                    color: Color.WHITE
                    radius: 4
                    height: 40
                }

                Image {
                    source: Res.ICON_PASSWORD
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    width: 18
                    height: 18
                }

                MouseArea {
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    width: 24
                    height: 24

                    Image {
                        id: eyeIcon
                        anchors.fill: parent
                        source: Res.ICON_EYE_CLOSED
                    }

                    onPressed: {
                        passwordField.echoMode = TextInput.Normal
                        eyeIcon.source = Res.ICON_EYE_OPEN
                    }
                    onReleased: {
                        passwordField.echoMode = TextInput.Password
                        eyeIcon.source = Res.ICON_EYE_CLOSED
                    }
                }
            }

            // Nút Đăng nhập
            Button {
                text: "Đăng nhập"
                width: parent.width
                height: 40
                font.pixelSize: 16

                background: Rectangle {
                    color: Color.WHITE
                    radius: 20
                }

                onClicked: {
                    if (usernameField.text.trim().length === 0 || passwordField.text.trim().length ===0 ) {
                        console.log("Invalid username or password")
                        return
                    }

                    appController.login(usernameField.text)
                    appController.connectToWebSocket(serverField.text)

                    stackView.push("qrc:/ChatView.qml", {
                        currentUserName: usernameField.text
                    })
                }
            }
        }
        Ani.FadeSlideIn {
            target: formColumn
            duration: 800
            offset: 60
        }


        // Ô Server góc dưới bên phải
        Row {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 10
            anchors.rightMargin: 10
            spacing: 5

            TextField {
                id: serverField
                //placeholderText: "ws://localhost:12345"
                text: "ws://192.168.1.11:12345"
                width: 200
                readOnly: true
                font.pixelSize: 14
                color: Color.TEXT
                focus: true
                background: Rectangle {
                    radius: 6
                    color: serverField.readOnly ? Color.WHITE : Color.SERVER_EDIT_BG
                    border.color: serverField.readOnly ?  Color.SERVER_EDIT_BORDER1 : Color.SERVER_EDIT_BORDER
                    border.width: 1

                    Behavior on color { ColorAnimation { duration: 250 } }
                    Behavior on border.color { ColorAnimation { duration: 250 } }
                }
            }

            Button {
                id: editButton
                width: 50
                height: 40

                background: Rectangle {
                    color: "#dddddd"
                    radius: height / 2
                    border.color: "#999"
                }

                contentItem: Text {
                    text: serverField.readOnly ? "Edit" : "Save"
                    color: "black"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.centerIn: parent
                    font.pixelSize: 14
                }

                onClicked: {
                    serverField.readOnly = !serverField.readOnly

                    if (!serverField.readOnly) {
                        serverField.forceActiveFocus()
                        serverField.cursorPosition = serverField.text.length
                    }
                }
            }
        }
    }
}
