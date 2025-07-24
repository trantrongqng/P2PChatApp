import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.platform 1.1

import "JS/Color.js" as Color
import "JS/resource.js" as Res

Rectangle {
    anchors.fill: parent
    color: Color.background
    property string currentUserName: ""

    ListModel { id: messageModel }

    FileDialog {
        id: imageDialog
        folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
        nameFilters: ["Image files (*.png *.jpg *.jpeg *.bmp)"]
        onAccepted: {
            var url = Qt.resolvedUrl(file)
            var localPath = url.toLocalFile ? url.toLocalFile() : file.toString().replace("file:///", "")
            console.log("📤 Gửi ảnh local path:", localPath)
            appController.sendImage(localPath)

            messageModel.append({
                text: "",
                imageSource: "file:///" + localPath,
                isSender: true
            })
            Qt.callLater(() => messageList.positionViewAtEnd())
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        ListView {
            id: messageList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: messageModel
            clip: true
            interactive: true

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                interactive: true
                contentItem: Rectangle {
                    implicitWidth: 5
                    radius: 3
                    color: Color.scrollBar
                    opacity: messageList.contentHeight > messageList.height ? 1.0 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }
                background: Rectangle { color: "transparent" }
            }

            delegate: Item {
                visible: model.text.trim().length > 0 || (model.imageSource && model.imageSource.length > 0)
                width: parent.width - 12
                height: bubbleContainer.implicitHeight + 10

                Item {
                    id: bubbleContainer
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    implicitHeight: rowContainer.implicitHeight

                    Row {
                        id: rowContainer
                        spacing: 10
                        anchors {
                            right: model.isSender ? parent.right : undefined
                            left: !model.isSender ? parent.left : undefined
                            margins: 10
                        }
                        Rectangle {
                            id: messageBubble
                            color: model.isSender ? Color.senderBubble : Color.receiverBubble
                            radius: 15
                            width: bubbleColumn.implicitWidth + 20
                            height: bubbleColumn.implicitHeight + 20

                            Column {
                                id: bubbleColumn
                                spacing: 5
                                anchors.centerIn: parent

                                Text {
                                    text: model.senderName
                                    visible: !model.isSender
                                    font.bold: true
                                    font.pixelSize: 12
                                    color: Color.senderName
                                }
                                Image {
                                    visible: model.imageSource && model.imageSource !== ""
                                    source: model.imageSource
                                    fillMode: Image.PreserveAspectFit
                                    width: 260
                                    height: sourceSize.height > 0 ? Math.min(sourceSize.height, 250) : implicitHeight
                                }
                                Text {
                                    text: model.text

                                    visible: text && text.trim() !== ""
                                    color: model.isSender ? Color.textSender : Color.textReceiver
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: 14
                                    width: Math.min(implicitWidth, 240)
                                }
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 5
            anchors.margins: 10
            Item { width: 5 }

            Item {
                width: 35
                height: 35
                Rectangle {
                    id: buttonBackground
                    width: 35
                    height: 35
                    radius: 15
                    color: "transparent"

                    Image {
                        source: Res.iconImage
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: imageDialog.open()
                        onPressed: buttonBackground.opacity = 0.6
                        onReleased: buttonBackground.opacity = 1.0
                        onEntered: buttonBackground.color = Color.hoverLight
                        onExited: {
                            buttonBackground.color = "transparent"
                            buttonBackground.opacity = 1.0
                        }
                    }
                }
            }

            Button {
                text: "🗑"
                onClicked: {
                    appController.clearMessages()
                    messageModel.clear()
                    var history = appController.loadHistoryMessages()
                    for (var i = 0; i < history.length; ++i) {
                        messageModel.append(history[i])
                    }
                }
            }

            TextField {
                id: inputField
                Layout.fillWidth: true
                placeholderText: "Aa"
                font.pixelSize: 16
                background: Rectangle {
                    color: "white"
                    radius: 20
                    border.color: Color.inputBorder
                }
                onAccepted: {
                    if (text.trim().length > 0) {
                        messageModel.append({
                            text: text,
                            imageSource: "",
                            isSender: true,
                            senderName: currentUserName
                        })
                        appController.sendMessage(text)
                        text = ""
                        messageList.positionViewAtEnd()
                    }
                }
            }

            Button {
                text: "Gửi"
                onClicked: {
                    if (inputField.text.trim().length > 0) {
                        messageModel.append({
                            text: inputField.text,
                            imageSource: "",
                            isSender: true,
                            senderName: currentUserName
                        })
                        appController.sendMessage(inputField.text)
                        inputField.text = ""
                        Qt.callLater(() => messageList.positionViewAtEnd())
                    }
                }
                background: Rectangle {
                    color: Color.senderBubble
                    radius: 20
                }
                contentItem: Text {
                    text: parent.text
                    color: Color.buttonText
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Connections {
                target: appController
                function onMessageReceived(text, imageSource, isSender, senderName) {
                    messageModel.append({
                        text: text,
                        imageSource: imageSource || "",
                        isSender: isSender,
                        senderName: senderName || ""
                    })
                    Qt.callLater(() => messageList.positionViewAtEnd())
                }
            }
        }
    }
    Component.onCompleted: {
        var history = appController.loadHistoryMessages()
        for (var i = 0; i < history.length; i++) {
            messageModel.append(history[i])
        }
        Qt.callLater(() => messageList.positionViewAtEnd())
    }
}
